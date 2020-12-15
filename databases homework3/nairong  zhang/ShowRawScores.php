<head>
  <title>List A Signle Student's Raw Score</title>
</head>

<body>



  <?php
  // PHP code just started

  ini_set('error_reporting', E_ALL);
  ini_set('display_errors', true);
  // display errors

  $mysqli = new mysqli("dbase.cs.jhu.edu", "20fa_nzhang50", "8kaFQbyTw8", "20fa_nzhang50_db");

  // ********* Remember to use your MySQL username and password here ********* //

  if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
  } else {
    $ssn = $_POST['ssn'];
    if (!$ssn) {
      printf("<br>No Input Detected: %s\n", $mysqli->error);
    }
    if (strlen($ssn) > 4) {
      printf("<br>Input SSN Length Exceeded: %s\n", $mysqli->error);
    }
    if (!is_numeric($ssn)) {
      printf("<br>Input SSN Contains Non-Integers: %s\n", $mysqli->error);
    }

    $query =  "CALL ShowPercentages($ssn) ; ";
    $result = $mysqli->query($query);
    // a simple query on the Student table

    if (!$result) {

      echo "Query Failed\n";
    } else {
      echo "<table border=1>\n";
      echo "<tr><td>SSN</td><td>FName</td><td>LName</td><td>Percentages For HW1</td><td>Percentages For HW2a</td><td>Percentages For HW2b</td><td>Percentages For Midterm</td><td>Percentages For HW3</td><td>Percentages For FinalExam</td></tr>\n";
      $SSN_Found = FALSE;
      $myrow = $result->fetch_row();
      echo "The cumulative course average for " . $myrow[1] . $myrow[2] . " is " . $myrow[3];
      if ($myrow) {
        $SSN_Found = TRUE;
        printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow[0], $myrow[1], $myrow[2], $myrow[4], $myrow[5], $myrow[6], $myrow[7], $myrow[8], $myrow[9]);
      }
      $result->close();
      if (!$SSN_Found) {
        echo "SSN Not Found!\n";
      }
      echo "</table>\n";
    }
  }

  // PHP code about to end

  ?>