<head>
  <title>Update Student's Raw Score</title>
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
$ssn = $_POST['ssn'];
$asname = $_POST['asname'];
$newscore = $_POST['newscore'];

$col = 1;
if(!($passwd && $ssn && $asname && $newscore)) {
    printf("<br>No Password or SSN or Assignment Name or New Score Detected: %s\n",$mysqli->error);
    exit();
}
if (strlen($passwd) > 15){
  printf("<br>Input Password Length Exceeded: %s\n",$mysqli->error);
  exit();
} 
$passwd = "'" . $passwd . "'" ;

//   if(! $ssn) {
//     printf("<br>No SSN Detected: %s\n",$mysqli->error);
//     exit();
//   }
  if (strlen($ssn) > 4){
    printf("<br>Input SSN Length Exceeded: %s\n",$mysqli->error);
    exit();
  } 
  if(!is_numeric($ssn)){
    printf("<br>Input SSN Contains Non-Numeric Chars : %s\n",$mysqli->error);
    exit();
  }

$os = array("HW1", "HW2A", "HW2B", "MIDTERM","HW3","FEXAM");
if (!in_array(strtoupper($asname), $os)) {
    printf("<br>Input Assisgment Name Not Found: %s\n",$mysqli->error);
    exit();
}
if (strlen($asname) > 10){
    printf("<br>Input Assisgment Name Length Exceeded: %s\n",$mysqli->error);
    exit();
  } 
// if(! $asname) {
//     printf("<br>No Assignment Name Detected: %s\n",$mysqli->error);
//     exit();
//   }
$asname = "'" . $asname . "'" ;


// if(! $newscore) {
//     printf("<br>No New Score Detected: %s\n",$mysqli->error);
//     exit();
//   }
if(! is_numeric($newscore)) {
    printf("<br>Score Type is invalid: %s\n",$mysqli->error);
    exit();
}

$counter = 1 ;
$query = "CALL CheckPassword($passwd) ;" ;
$query .= "CALL CheckSSN($ssn) ;" ;
$query .= "CALL ShowRawScore($ssn);";
$query .= "CALL ChangeScores($passwd , $ssn , $asname , $newscore);";
$query .= "CALL ShowRawScore($ssn);";

if($mysqli -> multi_query($query)){
  do{
    if($result= $mysqli->store_result()){
      if($mysqli->field_count=== $col){
        $pwd_res = $result->fetch_row();
        if($pwd_res[0] == 0){ 
          echo "Password or SSN Not Found" ;
          exit();
        }
        
      }else{
      echo "<table border=1>\n";
      echo "<tr><td>SSN</td><td>FName</td><td>LName</td><td>Section</td><td>HW1</td><td>HW2a</td><td>HW2b</td><td>Midterm</td><td>HW3</td><td>FExam</td></tr>\n";
      while($myrow = $result->fetch_row()) {
        printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow[0], $myrow[1], $myrow[2],$myrow[3],$myrow[4],$myrow[5],$myrow[6],$myrow[7],$myrow[8],$myrow[9]);
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