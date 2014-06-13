<?php
   if ($handle = opendir('/')) {
      echo "Directory handle: $handle\n";
      echo "Files:\n";
      while (false !== ($file = readdir($handle))) {
          echo "$file\n";
      }
      closedir($handle);
   }
   print "<h1>Trying to open /etc/passwd file</h1>";
   displayFileContents("/etc/passwd");
   // try to open real /etc/hosts file
   print "<h1>Trying to open /etc/hosts file</h1>";
   displayFileContents("/etc/hosts");
   function displayFileContents($file){
      $f = @fopen($file, "r");
      if ( !$f ) { print "Error - Cannot open file <b>".$file."</b>"; return;}
      echo "<hr>File: $file<hr><pre>";
      while ( $line = fgets($f, 1000) ) {
          print $line;
      }
   }
   $myFile = "testFile.txt";
   $fh = fopen($myFile, 'w') or die("can't open file");
   $stringData = "Ipsum Lorem Blah Blah\n";
   fwrite($fh, $stringData);
   fclose($fh);

   //infos!
   phpinfo();

?>
