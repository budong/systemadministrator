<html><body><h1>The page to test mysql local connection.</h1></body></html>
<?php
  $conn=mysql_connect('localhost','root','123456');
    if ($conn)
            echo "<h2>Success...</h2>";

      else
              echo "<h2>Failure...</h2>";
?>
