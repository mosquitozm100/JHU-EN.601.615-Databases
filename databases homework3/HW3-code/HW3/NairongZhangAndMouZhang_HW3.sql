create view WtdPtds as 
select 1/R1.HW1 * R2.HW1 as hw1, 1/R1.HW2a * R2.HW2a as hw2a , 1/R1.HW2b * R2.HW2b as hw2b, 1/R1.Midterm * R2.Midterm as midterm, 1/R1.HW3 * R2.Hw3 as hw3, 1/R1.FExam * R2.FExam as final
from Rawscores as R1, Rawscores as R2 
where R1.SSN = '0001' and R2.SSN ='0002';

DROP PROCEDURE IF EXISTS ShowPercentages //
CREATE PROCEDURE ShowPercentages(IN stuSSN varchar(4))
    SELECT R1.SSN , R1.FName , R1.LName ,(R1.HW1*WtdPtds.hw1 + R1.HW2a*WtdPtds.hw2a + R1.HW2b*WtdPtds.hw2b + R1.Midterm*WtdPtds.midterm + R1.HW3 * WtdPtds.hw3 + R1.FExam*WtdPtds.final) * 100  as Cum_Avg , R1.HW1 / R2.HW1 * 100  , R1.HW2a / R2.HW2a * 100 , R1.HW2b / R2.HW2b * 100 , R1.Midterm / R2.Midterm * 100 , R1.HW3 / R2.HW3 * 100 , R1.FExam / R2.FExam * 100  
    FROM WtdPtds , Rawscores as R1 , Rawscores as R2 
    WHERE R1.SSN = stuSSN AND R2.SSN = "0001";
//



DROP PROCEDURE IF EXISTS AllRawScores//
CREATE PROCEDURE AllRawScores()

    SELECT * FROM Rawscores WHERE Rawscores.SSN != "0001" AND Rawscores.SSN != "0002" ORDER BY SSN , LName , FName;

//

DROP PROCEDURE IF EXISTS CheckPassword//
CREATE PROCEDURE CheckPassword(IN passwd varchar(15))

    SELECT 
        CASE WHEN EXISTS 
            ( SELECT CurPasswords 
              FROM Passwords as PWD
              WHERE PWD.CurPasswords = passwd
                ) 
    THEN 1
    ELSE 0
    END AS ReturnVal
        
//

DROP PROCEDURE IF EXISTS CheckSSN//
CREATE PROCEDURE CheckSSN(IN ssnStu varchar(4))

    SELECT 
        CASE WHEN EXISTS 
            ( SELECT SSN 
              FROM Rawscores as R
              WHERE R.SSN = ssnStu
                ) 
    THEN 1
    ELSE 0
    END AS ReturnVal
        
//

DROP PROCEDURE IF EXISTS AllPercentages //
CREATE PROCEDURE AllPercentages()
    SELECT R1.SSN , R1.FName , R1.LName ,R1.Section , (R1.HW1*WtdPtds.hw1 + R1.HW2a*WtdPtds.hw2a + R1.HW2b*WtdPtds.hw2b + R1.Midterm*WtdPtds.midterm + R1.HW3 * WtdPtds.hw3 + R1.FExam*WtdPtds.final) * 100  as Cum_Avg , R1.HW1 / R2.HW1 * 100  , R1.HW2a / R2.HW2a * 100 , R1.HW2b / R2.HW2b * 100 , R1.Midterm / R2.Midterm * 100 , R1.HW3 / R2.HW3 * 100 , R1.FExam / R2.FExam * 100  
    FROM WtdPtds , Rawscores as R1 , Rawscores as R2 
    WHERE R2.SSN = "0001" AND R1.SSN != "0001" AND R1.SSN != "0002"
    ORDER BY R1.Section , Cum_Avg;
//
DROP VIEW IF EXISTS AllScores //
CREATE view AllScores as 
    SELECT (R1.HW1*WtdPtds.hw1 + R1.HW2a*WtdPtds.hw2a + R1.HW2b*WtdPtds.hw2b + R1.Midterm*WtdPtds.midterm + R1.HW3 * WtdPtds.hw3 + R1.FExam*WtdPtds.final) * 100  as Cum_Avg , R1.HW1 / R2.HW1 * 100 as hw1  , R1.HW2a / R2.HW2a * 100 as hw2a, R1.HW2b / R2.HW2b * 100 as hw2b, R1.Midterm / R2.Midterm * 100 as midterm , R1.HW3 / R2.HW3 * 100 as hw3, R1.FExam / R2.FExam * 100 as final 
    FROM WtdPtds , Rawscores as R1 , Rawscores as R2 
    WHERE R2.SSN = "0001" AND R1.SSN != "0001" AND R1.SSN != "0002"; //

DROP PROCEDURE IF EXISTS Stats//
CREATE PROCEDURE Stats(IN op VARCHAR(10))
BEGIN 
    IF op = "min" THEN SELECT "min",min(ALS.Cum_Avg),min(ALS.hw1) , min(ALS.hw2a) ,min(ALS.hw2b) , min(ALS.midterm) , min(ALS.hw3) , min(ALS.final) FROM AllScores as ALS  ;
    END IF ; 
    IF op = "max" THEN SELECT "max" ,max(ALS.Cum_Avg),max(ALS.hw1) , max(ALS.hw2a) ,max(ALS.hw2b) , max(ALS.midterm) , max(ALS.hw3) , max(ALS.final) FROM AllScores as ALS ;
    END IF ;
    IF op = "mean" THEN SELECT "mean" ,avg(ALS.Cum_Avg),avg(ALS.hw1) , avg(ALS.hw2a) ,avg(ALS.hw2b) , avg(ALS.midterm) , avg(ALS.hw3) , avg(ALS.final) FROM AllScores as ALS ;
    END IF ;
    IF op = "std" THEN SELECT  "std" ,STDDEV(ALS.Cum_Avg),STDDEV(ALS.hw1) , STDDEV(ALS.hw2a) ,STDDEV(ALS.hw2b) , STDDEV(ALS.midterm) , STDDEV(ALS.hw3) , STDDEV(ALS.final) FROM AllScores as ALS ;
    END IF ;

END   
//

DROP VIEW IF EXISTS AllScoresFor315 //
CREATE view AllScoresFor315 as 
    SELECT (R1.HW1*WtdPtds.hw1 + R1.HW2a*WtdPtds.hw2a + R1.HW2b*WtdPtds.hw2b + R1.Midterm*WtdPtds.midterm + R1.HW3 * WtdPtds.hw3 + R1.FExam*WtdPtds.final) * 100  as Cum_Avg , R1.HW1 / R2.HW1 * 100 as hw1  , R1.HW2a / R2.HW2a * 100 as hw2a, R1.HW2b / R2.HW2b * 100 as hw2b, R1.Midterm / R2.Midterm * 100 as midterm , R1.HW3 / R2.HW3 * 100 as hw3, R1.FExam / R2.FExam * 100 as final 
    FROM WtdPtds , Rawscores as R1 , Rawscores as R2 
    WHERE R2.SSN = "0001" AND R1.SSN != "0001" AND R1.SSN != "0002" AND R1.Section = "315" ; //

DROP VIEW IF EXISTS AllScoresFor415 //
CREATE view AllScoresFor415 as 
    SELECT (R1.HW1*WtdPtds.hw1 + R1.HW2a*WtdPtds.hw2a + R1.HW2b*WtdPtds.hw2b + R1.Midterm*WtdPtds.midterm + R1.HW3 * WtdPtds.hw3 + R1.FExam*WtdPtds.final) * 100  as Cum_Avg , R1.HW1 / R2.HW1 * 100 as hw1  , R1.HW2a / R2.HW2a * 100 as hw2a, R1.HW2b / R2.HW2b * 100 as hw2b, R1.Midterm / R2.Midterm * 100 as midterm , R1.HW3 / R2.HW3 * 100 as hw3, R1.FExam / R2.FExam * 100 as final 
    FROM WtdPtds , Rawscores as R1 , Rawscores as R2 
    WHERE R2.SSN = "0001" AND R1.SSN != "0001" AND R1.SSN != "0002" AND R1.Section = "415" ; //

DROP PROCEDURE IF EXISTS StatsExtra//
CREATE PROCEDURE StatsExtra(IN op VARCHAR(10) , IN sec VARCHAR(3))
BEGIN 
    IF op = "min" AND sec = "315" THEN SELECT "min for 315",min(ALS.Cum_Avg),min(ALS.hw1) , min(ALS.hw2a) ,min(ALS.hw2b) , min(ALS.midterm) , min(ALS.hw3) , min(ALS.final) FROM AllScoresFor315 as ALS  ;
    END IF ; 
    IF op = "max" AND sec = "315" THEN SELECT "max for 315" ,max(ALS.Cum_Avg),max(ALS.hw1) , max(ALS.hw2a) ,max(ALS.hw2b) , max(ALS.midterm) , max(ALS.hw3) , max(ALS.final) FROM AllScoresFor315 as ALS ;
    END IF ;
    IF op = "mean" AND sec = "315" THEN SELECT "mean for 315" ,avg(ALS.Cum_Avg),avg(ALS.hw1) , avg(ALS.hw2a) ,avg(ALS.hw2b) , avg(ALS.midterm) , avg(ALS.hw3) , avg(ALS.final) FROM AllScoresFor315 as ALS ;
    END IF ;
    IF op = "std" AND sec = "315" THEN SELECT  "std for 315" ,STDDEV(ALS.Cum_Avg),STDDEV(ALS.hw1) , STDDEV(ALS.hw2a) ,STDDEV(ALS.hw2b) , STDDEV(ALS.midterm) , STDDEV(ALS.hw3) , STDDEV(ALS.final) FROM AllScoresFor315 as ALS ;
    END IF ;
    IF op = "min" AND sec = "415" THEN SELECT "min for 415",min(ALS.Cum_Avg),min(ALS.hw1) , min(ALS.hw2a) ,min(ALS.hw2b) , min(ALS.midterm) , min(ALS.hw3) , min(ALS.final) FROM AllScoresFor415 as ALS  ;
    END IF ; 
    IF op = "max" AND sec = "415" THEN SELECT "max for 415" ,max(ALS.Cum_Avg),max(ALS.hw1) , max(ALS.hw2a) ,max(ALS.hw2b) , max(ALS.midterm) , max(ALS.hw3) , max(ALS.final) FROM AllScoresFor415 as ALS ;
    END IF ;
    IF op = "mean" AND sec = "415" THEN SELECT "mean for 415" ,avg(ALS.Cum_Avg),avg(ALS.hw1) , avg(ALS.hw2a) ,avg(ALS.hw2b) , avg(ALS.midterm) , avg(ALS.hw3) , avg(ALS.final) FROM AllScoresFor415 as ALS ;
    END IF ;
    IF op = "std" AND sec = "415" THEN SELECT  "std for 415" ,STDDEV(ALS.Cum_Avg),STDDEV(ALS.hw1) , STDDEV(ALS.hw2a) ,STDDEV(ALS.hw2b) , STDDEV(ALS.midterm) , STDDEV(ALS.hw3) , STDDEV(ALS.final) FROM AllScoresFor415 as ALS ;
    END IF ;   

END   
//

DROP PROCEDURE IF EXISTS ChangeScores//
CREATE PROCEDURE ChangeScores(IN passwd VARCHAR(15) , IN ssnStu VARCHAR(4) , IN asName VARCHAR(10) , IN newScore DECIMAL(5,2))
BEGIN 
    IF asName = "HW1" THEN UPDATE Rawscores SET HW1 = newScore WHERE Rawscores.SSN = ssnStu ;
    END IF ; 
    IF asName = "HW2a" THEN UPDATE Rawscores SET HW2a = newScore WHERE Rawscores.SSN = ssnStu ;
    END IF ;
    IF asName = "HW2b" THEN UPDATE Rawscores SET HW2b = newScore WHERE Rawscores.SSN = ssnStu ;
    END IF;
    IF asName = "Midterm" THEN UPDATE Rawscores SET Midterm = newScore WHERE Rawscores.SSN = ssnStu ;
    END IF ;
    IF asName = "HW3" THEN UPDATE Rawscores SET HW3 = newScore WHERE Rawscores.SSN = ssnStu ;
    END IF ;
    IF asName = "FExam" THEN UPDATE Rawscores SET FExam = newScore WHERE Rawscores.SSN = ssnStu ;
    END IF ;
END  
   
//

