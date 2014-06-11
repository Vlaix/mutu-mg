backend default {
    .host = "127.0.0.1";
    .port = "8080";
    .first_byte_timeout = 800s;
    .between_bytes_timeout = 800s;
    .connect_timeout = 800s;
}

acl purge {
        "127.0.0.1";
        "localhost";
}

sub vcl_recv {
        include "inc_recv.vcl";
        if (req.restarts == 0) {
                 if (req.http.x-forwarded-for) {
                             set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;
                 } else {
                        set req.http.X-Forwarded-For = client.ip;
                 }
        }
        set req.http.Host = regsub(req.http.Host, ":[0-9]+", "");
        if (req.request == "PURGE") {
                if (!client.ip ~ purge) {
                        error 405 "This IP is not allowed to send PURGE requests.";
                }        
                return (lookup);
        }
        if (req.http.Authorization || req.request == "POST") {
                return (pass);
        }
        
        if (req.url ~ "/feed") {
                return (pass);
        }
        if (req.url ~ "/mu-.*") {
                return (pass);
        }
        if (req.url ~ "/wp-(login|admin)") {
                return (pass);
        }
        set req.http.Cookie = regsuball(req.http.Cookie, "has_js=[^;]+(; )?", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "__utm.=[^;]+(; )?", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "__qc.=[^;]+(; )?", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "wp-settings-1=[^;]+(; )?", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "wp-settings-time-1=[^;]+(; )?", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "wordpress_test_cookie=[^;]+(; )?", "");
        if (req.http.cookie ~ "^ *$") {
                    unset req.http.cookie;
        }
        if (req.url ~ "\.(css|js|png|gif|jp(e)?g|swf|ico)") {
                unset req.http.cookie;
        }
        if (req.http.Accept-Encoding) {
                if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
                                   remove req.http.Accept-Encoding;
                } elsif (req.http.Accept-Encoding ~ "gzip") {
                            set req.http.Accept-Encoding = "gzip";
                } elsif (req.http.Accept-Encoding ~ "deflate") {
                            set req.http.Accept-Encoding = "deflate";
                } else {
                        remove req.http.Accept-Encoding;
                }
        }
        if (req.http.Cookie ~ "wordpress_" || req.http.Cookie ~ "comment_") {
                return (pass);
        }
        if (!req.http.cookie) {
                unset req.http.cookie;
        }
        if (req.http.Authorization || req.http.Cookie) {
                return (pass);
        }
        set req.grace = 30s;
        return (lookup);
}
 
sub vcl_pipe {
        return (pipe);
}
 
sub vcl_pass {
        return (pass);
}
 
sub vcl_hash {
         hash_data(req.url);
         if (req.http.host) {
             hash_data(req.http.host);
         } else {
             hash_data(server.ip);
         }
         if (req.http.Accept-Encoding) {
                hash_data(req.http.Accept-Encoding);
         }
     
        return (hash);
}
 
sub vcl_hit {
        if (req.request == "PURGE") {
                purge;
                error 200 "Purged.";
        }
        return (deliver);
}
 
sub vcl_miss {
        if (req.request == "PURGE") {
                purge;
                error 200 "Purged.";
        }
        
        return (fetch);
}

sub vcl_fetch {
        unset beresp.http.Server;
        unset beresp.http.X-Powered-By;
        if (req.url ~ "\.(css|js|png|gif|jp(e?)g)|swf|ico") {
                unset beresp.http.cookie;
        }
        if (beresp.http.Set-Cookie && req.url !~ "^/wp-(login|admin)") {
                unset beresp.http.Set-Cookie;
            }
        if ( req.request == "POST" || req.http.Authorization ) {
                return (hit_for_pass);
            }
 
        if ( req.url ~ "\?s=" ){
                return (hit_for_pass);
        }
    
        if ( beresp.status != 200 ) {
                return (hit_for_pass);
        }
        set beresp.ttl = 24h;
        return (deliver);
}
 
sub vcl_deliver {
        if (obj.hits > 0) { 
                set resp.http.X-Cache = "cached";
        } else {
                set resp.http.x-Cache = "uncached";
        }
        unset resp.http.X-Powered-By;
        unset resp.http.Server;
        unset resp.http.Via;
        unset resp.http.X-Varnish;

        return (deliver);
}
 
sub vcl_init {
         return (ok);
}
 
sub vcl_fini {
         return (ok);
}
