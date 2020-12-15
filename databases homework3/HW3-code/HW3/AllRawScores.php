<head>
  <title>List All Student's Raw Score</title>
 </head>
 <body>



 <?php
// PHP code just started

$mysqli = new mysqli("dbase.cs.jhu.edu","20fa_nzhang50","8kaFQbyTw8","20fa_nzhang50_db");
ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);
// display errors

if (mysqli_connect_errno()) {
  printf("Connect failed: %s\n", mysqli_connect_error());
  exit();
}
$passwd = $_POST['passwd'];
$col = 1;
if(!$passwd) {
  printf("<br>No Password Detected: %s\n",$mysqli->error);
  exit();
}
if (strlen($passwd) > 15){
  printf("<br>Input Length Exceeded: %s\n",$mysqli->error);
  exit();
} 
$passwd = "'" . $passwd . "'" ;

$query = "CALL CheckPassword($passwd) ;" ;
$query .= "CALL AllRawSCores() ;";
if($mysqli -> multi_query($query)){
  do{
    if($result= $mysqli->store_result()){
      if($mysqli->field_count=== $col){
        $pwd_res = $result->fetch_row();
        if($pwd_res[0] == 0){ 
          echo "Invalid Password" ;
          exit();
        }
      }else{
      echo "<table border=1>\n";
      echo "<tr><td>SSN</td><td>FName</td><td>LName</td><td>Section</td><td>HW1</td><td>HW2a</td><td>HW2b</td><td>Midterm</td><td>HW3</td><td>FExam</td></tr>\n";
      while($myrow = $result->fetch_row()) {
        printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow[0], $myrow[1], $myrow[2],$myrow[3],$myrow[4], $myrow[5], $myrow[6],$myrow[7],$myrow[8],$myrow[9]);
      }
      echo "</table>\n";
      $result-> close();
      }
    }
  
  }while($mysqli->more_results() && $mysqli->next_result());
}
else{
  printf("<br>Query Failed: %s\n",$mysqli->error);
  exit();
}



 ?>