/*Question 1*/
SELECT S1.Fname,
    S1.LName,
    S2.Fname,
    S2.LName
FROM Student AS S1,
    Student AS S2
WHERE S1.city_code = S2.city_code
    AND S1.StuID IN (
        SELECT WhoLikes
        FROM Likes
        WHERE WhoIsLiked = S2.StuID
    )
    AND S1.StuID NOT IN (
        SELECT WhoLoves
        FROM Loves
        WHERE WhoIsLoved = S2.StuID
    )
    AND S2.StuID IN (
        SELECT WhoLikes
        FROM Likes
        WHERE WhoIsLiked = S1.StuID
    )
    AND S2.StuID NOT IN (
        SELECT WhoLoves
        FROM Loves
        WHERE WhoIsLoved = S1.StuID
    )
    AND S1.StuID > S2.StuID;
/*Question 2*/
SELECT S.Fname,
    S.LName,
    C.CarManufacturer,
    C.CarModel,
    C.miles_per_gallon
FROM Student as S,
    Car AS C,
    Car_Ownership AS CO
WHERE S.StuID = CO.StuID
    AND CO.CarID = C.CarID
    AND C.miles_per_gallon IN (
        SELECT MIN(miles_per_gallon)
        FROM Car
    );
/*Question 3*/
SELECT DISTINCT S.Fname,
    S.LName,
    S.Age,
    S.Major
FROM Student AS S
WHERE NOT EXISTS (
        (
            SELECT C.CarModel
            FROM Car AS C
            WHERE C.CarManufacturer = "Nissan"
        )
        EXCEPT (
                SELECT C.CarModel
                FROM Car AS C,
                    Car_Ownership AS CO
                WHERE CO.StuID = S.StuID
                    AND C.CarID = CO.CarID
            )
    );
/*Question 4*/
SELECT Fname,
    LName
FROM Student AS S,
    Lives_in AS L
WHERE S.StuID = L.stuid
    AND S.StuID IN (
        SELECT StuID
        FROM Car_Ownership AS C
        GROUP BY StuID
        HAVING COUNT(CarID) > 1
    );
/*Question 5*/
SELECT Fname,
    LName
FROM Student AS S,
    Lives_in AS L
WHERE S.StuID = L.stuid
    AND S.StuID IN (
        SELECT StuID
        FROM Has_Pet AS H
    )
    AND S.StuID NOT IN (
        SELECT StuID
        FROM Car_Ownership AS C
    );
/*Question 6*/
SELECT Fname,
    LName
FROM Student AS S,
    Lives_in AS L
WHERE S.StuID = L.stuid
    AND S.StuID IN (
        SELECT StuID
        FROM Car_Ownership AS C
        GROUP BY StuID
        HAVING COUNT(CarID) = 2
    )
    AND S.StuID IN (
        SELECT StuID
        FROM Has_Pet AS C
        GROUP BY StuID
        HAVING COUNT(PetID) >= 2
    );
/*Question 7*/
SELECT MIN(C.miles_per_gallon),
    MAX(miles_per_gallon),
    AVG(miles_per_gallon)
FROM Car AS C
WHERE C.CarManufacturer = "Porsche";
/*Question 8*/
SELECT MIN(S.Age),
    MAX(S.Age),
    AVG(S.Age)
FROM Student AS S,
    Lives_in AS L
WHERE S.StuID = L.stuid
    AND S.StuID NOT IN (
        SELECT CO.StuID
        FROM Car_Ownership AS CO
    );
/*Question 9*/
SELECT S.Fname,
    S.LName,
    S.Age
FROM Student AS S
WHERE S.StuID NOT IN (
        SELECT L.stuid
        FROM Lives_in AS L
    );
/*Question 10*/
SELECT AVG(S.Age)
FROM Student AS S
WHERE S.StuID IN (
        SELECT PI.stuid
        FROM Participates_in AS PI
        GROUP BY PI.stuid
        HAVING COUNT(PI.actid) > 2
    );
/*Question 11*/
SELECT A.activity_name,
    B.Number
FROM Activity AS A,
    (
        SELECT PI.actid,
            COUNT(PI.stuid) AS Number
        FROM Participates_in AS PI
        GROUP BY PI.actid
    ) AS B
WHERE A.actid = B.actid
HAVING B.Number = (
        SELECT MAX(B.Number)
        FROM (
                SELECT PI.actid,
                    COUNT(PI.stuid) AS Number
                FROM Participates_in AS PI
                GROUP BY PI.actid
            ) AS B
    );
/*Question 12*/
SELECT A.activity_name
FROM Activity AS A
WHERE A.actid IN (
        SELECT actid
        FROM Faculty_Participates_in
    )
    AND A.actid NOT IN (
        SELECT actid
        FROM Participates_in
    );
/*Question 13*/
SELECT S.Fname,
    S.LName
FROM Student AS S
WHERE S.StuID IN (
        SELECT DISTINCT E1.StuID
        FROM Enrolled_in AS E1,
            Enrolled_in AS E2
        WHERE E1.CID = E2.CID
            AND E1.StuID <> E2.StuID
            AND E2.StuID IN (
                SELECT DISTINCT E1.StuID
                FROM Enrolled_in AS E1,
                    Enrolled_in AS E2
                WHERE E1.CID = E2.CID
                    AND E1.StuID <> E2.StuID
                    AND E2.StuID IN (
                        SELECT DISTINCT L1.stuid
                        FROM Lives_in AS L1,
                            Lives_in AS L2
                        WHERE L1.dormid = L2.dormid
                            AND L1.room_number = L2.room_number
                            AND L1.stuid <> L2.stuid
                            AND L2.stuid IN (
                                SELECT S.StuID
                                FROM Student AS S
                                WHERE S.city_code IN (
                                        SELECT City.city_code
                                        FROM City
                                        WHERE City.state = "PA"
                                    )
                                    AND S.StuID IN (
                                        SELECT StuID
                                        FROM VotedForElectioninUS
                                        WHERE Year = "2020"
                                            AND CandidateID = (
                                                SELECT CandidateID
                                                FROM USCandidate
                                                WHERE CandidateName = "Donald Trump"
                                            )
                                    )
                            )
                    )
            )
    );
/*Question 14*/
SELECT DISTINCT S.Fname,
    S.LName,
    F.Fname,
    F.LName
FROM Student AS S,
    Faculty AS F
WHERE S.Advisor = F.FacID
    AND EXISTS (
        SELECT *
        FROM Participates_in AS P,
            Faculty_Participates_in AS FP
        WHERE S.StuID = P.stuid
            AND F.FacID = FP.FacID
            AND P.actid = FP.actid
    )
    AND F.FacID IN (
        SELECT Instructor
        FROM Course
    );
/*Question 15*/
SELECT S1.Fname,
    S1.LName,
    S2.Fname,
    S2.LName
FROM Student AS S1,
    Student As S2
WHERE S1.StuID > S2.StuID
    AND (S1.StuID, S2.StuID) IN (
        SELECT DISTINCT L1.stuid,
            L2.stuid
        FROM Lives_in AS L1,
            Lives_in AS L2
        WHERE L1.dormid = L2.dormid
            AND L1.room_number = L2.room_number
            AND L1.stuid <> L2.stuid
    )
    AND EXISTS(
        SELECT *
        FROM City AS C1,
            City As C2
        WHERE C1.city_code = S1.city_code
            AND C2.city_code = S2.city_code
            AND C1.country <> C2.country
    );
/*Question 16*/
SELECT D.dormid,
    D.dorm_name,
    E.StuID,
    SUM(G.gradepoint * C.Credits) / SUM(C.Credits) AS GPA
FROM (
        SELECT DISTINCT *
        FROM Enrolled_in
    ) AS E,
    Course AS C,
    Gradeconversion AS G,
    Lives_in AS L,
    Dorm AS D
WHERE E.Grade = G.lettergrade
    AND E.CID = C.CID
    AND E.StuID = L.stuid
    AND D.dormid = L.dormid
GROUP BY E.StuID
HAVING GPA = (
        SELECT MAX(M.GPA)
        FROM (
                SELECT E.StuID,
                    SUM(G.gradepoint * C.Credits) / SUM(C.Credits) AS GPA
                FROM (
                        SELECT DISTINCT *
                        FROM Enrolled_in
                    ) AS E,
                    Course AS C,
                    Gradeconversion AS G
                WHERE E.Grade = G.lettergrade
                    AND E.CID = C.CID
                GROUP BY E.StuID
            ) AS M
    );
/*Question 17(1)*/
DROP table IF EXISTS Baltimore_Distance;
CREATE table Baltimore_Distance (
    city1_code varchar(3),
    city2_code varchar(3),
    distance INTEGER
);
INSERT INTO Baltimore_Distance
SELECT DISTINCT DD1.city2_code,
    DD2.city2_code,
    DD1.distance + DD2.distance
FROM Direct_distance AS DD1,
    Direct_distance AS DD2
WHERE DD1.city1_code = "BAL"
    AND DD2.city1_code = "BAL";
/*Question 17(2)*/
DROP table IF EXISTS Rectangular_Distance;
CREATE table Rectangular_Distance (
    city1_code varchar(3),
    city2_code varchar(3),
    distance FLOAT
);
INSERT INTO Rectangular_Distance
SELECT DISTINCT C1.city_code,
    C2.city_code,
    SQRT(
        POWER((70 * C1.latitude - 70 * C2.latitude), 2) + POWER((70 * C1.longitude - 70 * C2.longitude), 2)
    )
FROM City AS C1,
    City AS C2;
/*Question 17(3)*/
DROP table IF EXISTS All_Distance;
CREATE table All_Distance (
    city1_code varchar(3),
    city2_code varchar(3),
    Direct_distance FLOAT,
    Baltimore_Distance FLOAT,
    Rectangular_Distance FLOAT
);
INSERT INTO All_Distance (
        SELECT ALL_CIR.city1_code,
            ALL_CIR.city2_code,
            MAX(DD_Dist),
            MAX(BD_Dist),
            MAX(RD_Dist)
        FROM (
                (
                    SELECT DD.city1_code,
                        DD.city2_code,
                        DD.distance AS DD_Dist,
                        NULL AS BD_Dist,
                        NULL AS RD_Dist
                    FROM Direct_distance AS DD
                )
                UNION
                (
                    SELECT BD.city1_code,
                        BD.city2_code,
                        NULL AS DD_Dist,
                        BD.distance AS BD_Dist,
                        NULL AS RD_Dist
                    FROM Baltimore_Distance AS BD
                )
                UNION
                (
                    SELECT RD.city1_code,
                        RD.city2_code,
                        NULL AS DD_Dist,
                        NULL AS BD_Dist,
                        RD.distance AS RD_Dist
                    FROM Rectangular_Distance AS RD
                )
            ) AS ALL_CIR
        GROUP BY ALL_CIR.city1_code,
            ALL_CIR.city2_code
    );
/*Question 17(4)*/
DROP table IF EXISTS Best_Distance;
CREATE table Best_Distance (
    city1_code varchar(3),
    city2_code varchar(3),
    distance FLOAT
);
INSERT INTO Best_Distance (
        SELECT Best_dist.city1_code,
            Best_dist.city2_code,
            Best_dist.distance
        FROM (
                (
                    SELECT DISTINCT A.city1_code,
                        A.city2_code,
                        A.Direct_distance AS distance
                    FROM All_Distance AS A
                    WHERE A.Direct_distance IS NOT NULL
                        AND A.Direct_distance <= A.Baltimore_Distance
                        AND A.Direct_distance <= A.Rectangular_Distance
                )
                UNION
                (
                    SELECT DISTINCT A.city1_code,
                        A.city2_code,
                        A.Baltimore_Distance AS distance
                    FROM All_Distance AS A
                    WHERE (
                            A.Direct_distance IS NULL
                            OR A.Baltimore_Distance <= A.Direct_distance
                        )
                        AND A.Baltimore_Distance <= A.Rectangular_Distance
                )
                UNION
                (
                    SELECT DISTINCT A.city1_code,
                        A.city2_code,
                        A.Rectangular_Distance AS distance
                    FROM All_Distance AS A
                    WHERE (
                            A.Direct_distance IS NULL
                            OR A.Rectangular_Distance <= A.Direct_distance
                        )
                        AND A.Rectangular_Distance <= A.Baltimore_Distance
                )
            ) AS Best_dist
    );
/*Question 18*/
SELECT DISTINCT C.city_name,
    Number
FROM City AS C,
    (
        SELECT DISTINCT S.city_code,
            COUNT(S.StuID) AS Number
        FROM Student AS S
        GROUP BY S.city_code
        HAVING COUNT(S.StuID) >= 2
    ) AS B
WHERE C.city_code = B.city_code;
/*Question 19*/
SELECT DISTINCT S.Fname,
    S.LName,
    C.city_name,
    C.state,
    C.country
FROM Student AS S,
    City As C
WHERE S.city_code = C.city_code
    AND S.StuID IN (
        SELECT DISTINCT L.stuid
        FROM Lives_in AS L
        WHERE L.dormid IN (
                SELECT D.dormid
                FROM Dorm AS D
                WHERE D.student_capacity < 300
            )
            AND EXISTS(
                SELECT *
                FROM Lives_in AS L2
                WHERE L.dormid = L2.dormid
                    AND L.stuid <> L2.stuid
                    AND EXISTS(
                        SELECT *
                        FROM Best_Distance AS BD,
                            Student AS S2,
                            Student AS S3
                        WHERE L.stuid = S2.StuID
                            AND L2.stuid = S3.StuID
                            AND (
                                (
                                    S2.city_code = BD.city1_code
                                    AND S3.city_code = BD.city2_code
                                )
                                OR (
                                    S3.city_code = BD.city1_code
                                    AND S2.city_code = BD.city2_code
                                )
                            )
                            AND BD.distance <= 100
                    )
            )
    );
/*Question 20*/
SELECT DISTINCT S.Fname,
    S.LName,
    C.country,
    BD.Distance
FROM Student AS S,
    City AS C,
    Best_Distance AS BD,
    (
        SELECT C.country,
            MAX(BD.distance) AS MaxDistance
        FROM Student AS S,
            City AS C,
            Best_Distance AS BD
        WHERE S.city_code = C.city_code
            AND (
                (
                    BD.city1_code = S.city_code
                    AND BD.city2_code = "BAL"
                )
                OR (
                    BD.city2_code = S.city_code
                    AND BD.city1_code = "BAL"
                )
            )
        GROUP BY C.country
    ) AS MaxCountry
WHERE S.city_code = C.city_code
    AND (
        (
            BD.city1_code = S.city_code
            AND BD.city2_code = "BAL"
        )
        OR (
            BD.city2_code = S.city_code
            AND BD.city1_code = "BAL"
        )
    )
    AND BD.distance = MaxCountry.MaxDistance
    AND C.country = MaxCountry.country;
/*Question 21*/
SELECT A.activity_name,
    avgDistanceByActivity.distance
FROM Activity AS A,
    (
        SELECT P1.actid AS actid,
            AVG(BD.distance) AS distance
        FROM Student AS S1,
            Participates_in AS P1,
            Best_Distance AS BD
        WHERE S1.StuID = P1.stuid
            AND (
                BD.city1_code = "BAL"
                AND BD.city2_code = S1.city_code
            )
        GROUP BY P1.actid
    ) AS avgDistanceByActivity
WHERE A.actid = avgDistanceByActivity.actid
HAVING avgDistanceByActivity.distance = (
        SELECT MAX(AVG.distance)
        FROM (
                SELECT P1.actid AS actid,
                    AVG(BD.distance) AS distance
                FROM Student AS S1,
                    Participates_in AS P1,
                    Best_Distance AS BD
                WHERE S1.StuID = P1.stuid
                    AND (
                        BD.city1_code = "BAL"
                        AND BD.city2_code = S1.city_code
                    )
                GROUP BY P1.actid
            ) AS AVG
    );
/*Question 22*/
SELECT S.Fname,
    S.LName,
    S.Age
FROM Student AS S,
    Minor_in AS M,
    Department AS D
WHERE S.Sex = "F"
    AND S.StuID = M.StuID
    AND M.DNO = D.DNO
    AND D.Division = "EN"
    AND EXISTS(
        SELECT *
        FROM Enrolled_in AS E,
            Course AS C,
            Faculty AS F,
            Member_of AS M,
            Department AS D
        WHERE S.StuID = E.StuID
            AND E.CID = C.CID
            AND C.Instructor = F.FacID
            AND F.FacID = M.FacID
            AND F.Sex = "F"
            AND M.Appt_Type = "Primary"
            AND M.DNO = D.DNO
            AND D.Division = "EN"
    );
/*Question 23*/
SELECT S.Fname,
    S.LName,
    S.StuID
FROM Student AS S
WHERE NOT EXISTS (
        (
            SELECT C.CID
            FROM Course AS C,
                Faculty AS F
            WHERE C.Instructor = F.FacID
                AND F.Fname = "Paul"
                AND F.Lname = "Smolensky"
        )
        EXCEPT (
                SELECT E.CID
                FROM Enrolled_in AS E
                WHERE S.StuID = E.StuID
            )
    );
/*Question 24*/
SELECT DISTINCT S.Fname,
    S.Lname,
    S.StuID
FROM Student AS S,
    Student AS SL,
    City AS C1,
    City AS C2,
    VotedForElectioninUS AS V1,
    VotedForElectioninUS AS V2,
    VotedForElectioninUS AS V3,
    VotedForElectioninUS AS V4,
    USCandidateFor AS CF1,
    USCandidateFor AS CF2,
    USCandidateFor AS CF3,
    USCandidateFor AS CF4
WHERE V1.StuID = S.StuID
    AND V2.StuID = SL.StuID
    AND V1.Year = 2016
    AND V2.Year = 2016
    AND V1.CandidateID = V2.CandidateID
    AND V1.CandidateID = CF1.CandidateID
    AND V2.CandidateID = CF2.CandidateID
    AND CF1.Office = "President"
    AND CF2.Office = "President"
    AND CF1.Year = 2016
    AND CF2.Year = 2016
    AND V3.StuID = S.StuID
    AND V4.StuID = SL.StuID
    AND V3.Year = 2020
    AND V4.Year = 2020
    AND V3.CandidateID = V4.CandidateID
    AND V3.CandidateID = CF3.CandidateID
    AND V4.CandidateID = CF4.CandidateID
    AND CF3.Office = "President"
    AND CF4.Office = "President"
    AND CF3.Year = 2020
    AND CF4.Year = 2020
    AND S.City_code = C1.City_code
    AND SL.Fname = "Linda"
    AND SL.Lname = "Smith"
    AND SL.City_code = C2.City_Code
    AND C1.State = C2.State
    AND EXISTS (
        SELECT E1.CID
        FROM Enrolled_in AS E1,
            Enrolled_in AS E2
        WHERE S.StuID = E1.StuID
            AND E1.CID = E2.CID
            AND E2.StuID IN (
                SELECT S1.StuID
                FROM Student AS S1
                WHERE EXISTS (
                        SELECT E1.CID
                        FROM Enrolled_in AS E1,
                            Enrolled_in AS E2,
                            Student AS S2
                        WHERE E1.CID = E2.CID
                            AND E1.StuID = S1.StuID
                            AND E2.StuID = S2.StuID
                            AND S2.Fname = "Linda"
                            AND S2.Lname = "Smith"
                    )
            )
    );
/*Question 25*/
SELECT DISTINCT C.CName
FROM Student AS S,
    Enrolled_in AS E,
    Course AS C
WHERE S.StuID IN (
        SELECT S1.StuID
        FROM Student AS S1,
            Student AS S2,
            Likes AS L
        WHERE S1.StuID NOT IN (
                SELECT M.StuID
                FROM Member_of_club AS M
            )
            AND S1.StuID NOT IN (
                SELECT H.StuID
                FROM Has_Allergy AS H
            )
            AND L.WhoLikes = S1.StuID
            AND L.WhoIsLiked = S2.StuID
            AND S2.StuID IN (
                SELECT M.StuID
                FROM Member_of_club AS M
            )
            AND S2.StuID IN (
                SELECT H.StuID
                FROM Has_Allergy AS H
            )
    )
    AND S.StuID = E.StuID
    AND E.CID = C.CID;
/*Question 26*/
SELECT S.Fname,
    S.LName,
    D.dorm_name,
    C.Number
FROM Student AS S,
    Lives_in AS L,
    Dorm AS D,
    (
        SELECT CV.StuID,
            COUNT(CV.StuID) AS Number
        FROM ConductViolation AS CV
        GROUP BY CV.StuID
    ) AS C
WHERE S.StuID = C.StuID
    AND S.StuID = L.stuid
    AND L.dormid = D.dormid;
/*Question 27*/
SELECT S.Fname,
    S.LName,
    D.dorm_name,
    C.Number AS Number
FROM Student AS S,
    Lives_in AS L,
    Dorm AS D,
    (
        SELECT CV.StuID,
            COUNT(CV.StuID) AS Number
        FROM ConductViolation AS CV
        GROUP BY CV.StuID
    ) AS C,
    (
        SELECT MAX(C.Number) AS maxNumber
        FROM Student AS S,
            Lives_in AS L,
            Dorm AS D,
            (
                SELECT CV.StuID,
                    COUNT(CV.StuID) AS Number
                FROM ConductViolation AS CV
                GROUP BY CV.StuID
            ) AS C
        WHERE S.StuID = C.StuID
            AND S.StuID = L.stuid
            AND L.dormid = D.dormid
    ) AS M
WHERE S.StuID = C.StuID
    AND S.StuID = L.stuid
    AND L.dormid = D.dormid
    AND C.Number = M.maxNumber;
/*Question 29*/
SELECT C.CName,
    C.DNO,
    COUNT(CV.StuID)
FROM Course AS C,
    Enrolled_in AS E,
    ConductViolation AS CV
WHERE C.CID = E.CID
    AND CV.StuID = E.StuID
GROUP BY CName
Having COUNT(CV.StuID) = (
        SELECT MAX(M.Number) AS Number
        FROM (
                SELECT C.CName,
                    COUNT(CV.StuID) AS Number
                FROM Course AS C,
                    Enrolled_in AS E,
                    ConductViolation AS CV
                WHERE C.CID = E.CID
                    AND CV.StuID = E.StuID
                GROUP BY C.CName
            ) AS M
    );
/*Question 30*/
SELECT ClubName
FROM (
        SELECT M.ClubID,
            SUM(C.Number) AS Number
        FROM (
                SELECT CV.StuID,
                    COUNT(CV.StuID) AS Number
                FROM ConductViolation AS CV
                GROUP BY CV.StuID
            ) AS C,
            Member_of_club AS M
        WHERE M.StuID = C.StuID
        GROUP BY M.ClubID
    ) AS M,
    Club AS C
WHERE C.ClubID = M.ClubID
    AND M.Number > 3;
/*Question 31*/
SELECT S1.Fname,
    S1.LName,
    USC1.CandidateName,
    S2.Fname,
    S2.LName,
    USC2.CandidateName
FROM Student AS S1,
    Student AS S2,
    Lives_in AS L1,
    Lives_in AS L2,
    VotedForElectioninUS AS VFEU1,
    VotedForElectioninUS AS VFEU2,
    USCandidate AS USC1,
    USCandidate AS USC2,
    USCandidateFor AS USCF1,
    USCandidateFor AS USCF2
WHERE VFEU1.StuID = S1.StuID
    AND VFEU2.StuID = S2.StuID
    AND S1.StuID = L1.stuid
    AND S2.StuID = L2.stuid
    AND L1.dormid = L2.dormid
    AND VFEU1.CandidateID = USC1.CandidateId
    AND VFEU2.CandidateID = USC2.CandidateId
    AND VFEU1.CandidateID = USCF1.CandidateID
    AND VFEU2.CandidateID = USCF2.CandidateID
    AND USCF1.Office = "President"
    AND USCF2.Office = "President"
    AND VFEU1.CandidateID <> VFEU2.CandidateID
    AND S1.StuID < S2.StuID;
/*Question 32*/
SELECT D.dorm_name,
    M.Number
FROM Dorm AS D,
    (
        SELECT L.dormid,
            COUNT(L.stuid) AS Number
        FROM Lives_in AS L
        WHERE L.stuid IN (
                SELECT VFEU.StuID
                FROM VotedForElectioninUS AS VFEU,
                    USCandidate AS USC
                WHERE VFEU.CandidateID = USC.CandidateId
                    AND USC.CandidateName = "Donald Trump"
                    AND VFEU.Year = '2020'
            )
        GROUP BY L.dormid
    ) AS M
WHERE D.dormid = M.dormid
HAVING M.Number = (
        SELECT MAX(M.Number)
        FROM (
                SELECT L.dormid,
                    COUNT(L.stuid) AS Number
                FROM Lives_in AS L
                WHERE L.stuid IN (
                        SELECT VFEU.StuID
                        FROM VotedForElectioninUS AS VFEU,
                            USCandidate AS USC
                        WHERE VFEU.CandidateID = USC.CandidateId
                            AND USC.CandidateName = "Donald Trump"
                            AND VFEU.Year = '2020'
                    )
                GROUP BY L.dormid
            ) AS M
    );
/*Question 33*/
SELECT D.dorm_name,
    D.dormid,
    M.Percent
FROM (
        SELECT L.dormid,
            COUNT(L.stuid) / M.TotalNum AS Percent
        FROM Lives_in AS L,
            (
                SELECT L.dormid,
                    COUNT(L.stuid) AS TotalNum
                FROM Lives_in AS L
                GROUP BY L.dormid
            ) AS M
        WHERE L.dormid = M.dormid
            AND L.stuid IN (
                SELECT VFEU.StuID
                FROM VotedForElectioninUS AS VFEU,
                    USCandidate AS USC
                WHERE VFEU.CandidateID = USC.CandidateId
                    AND USC.CandidateName = "Donald Trump"
                    AND VFEU.Year = '2020'
            )
        GROUP BY L.dormid
    ) AS M,
    Dorm AS D
WHERE M.dormid = D.dormid
HAVING M.Percent = (
        SELECT MAX(M.Percent)
        FROM (
                SELECT L.dormid,
                    COUNT(L.stuid) / M.TotalNum AS Percent
                FROM Lives_in AS L,
                    (
                        SELECT L.dormid,
                            COUNT(L.stuid) AS TotalNum
                        FROM Lives_in AS L
                        GROUP BY L.dormid
                    ) AS M
                WHERE L.dormid = M.dormid
                    AND L.stuid IN (
                        SELECT VFEU.StuID
                        FROM VotedForElectioninUS AS VFEU,
                            USCandidate AS USC
                        WHERE VFEU.CandidateID = USC.CandidateId
                            AND USC.CandidateName = "Donald Trump"
                            AND VFEU.Year = '2020'
                    )
                GROUP BY L.dormid
            ) AS M
    );
/*Question 34*/
SELECT S.Fname,
    S.LName,
    S.Age,
    USC1.CandidateName,
    USC1.Party AS 2016VoteParty,
    USC2.CandidateName,
    USC2.Party AS 2020VoteParty
FROM VotedForElectioninUS AS VFEU1,
    VotedForElectioninUS AS VFEU2,
    USCandidate AS USC1,
    USCandidate AS USC2,
    Student AS S,
    USCandidateFor AS USCF1,
    USCandidateFor AS USCF2
WHERE VFEU1.StuID = VFEU2.StuID
    AND VFEU1.StuID = S.StuID
    AND VFEU1.CandidateID <> VFEU2.CandidateID
    AND VFEU1.Year = '2016'
    AND VFEU2.Year = '2020'
    AND VFEU1.CandidateID = USC1.CandidateId
    AND VFEU2.CandidateID = USC2.CandidateId
    AND VFEU1.CandidateID = USCF1.CandidateID
    AND VFEU2.CandidateID = USCF2.CandidateID
    AND USCF1.Office = "President"
    AND USCF2.Office = "President"
    AND USCF1.Year = "2016"
    AND USCF2.Year = "2020";
/*Question 35*/
SELECT DISTINCT S.Fname,
    S.LName,
    C.state
FROM VotedForElectioninUS AS VFEU1,
    VotedForElectioninUS AS VFEU2,
    USCandidate AS USC1,
    USCandidate AS USC2,
    Student AS S,
    City AS C
WHERE VFEU1.StuID = VFEU2.StuID
    AND VFEU1.StuID = S.StuID
    AND VFEU1.Year <> VFEU2.Year
    AND VFEU1.CandidateID = USC1.CandidateId
    AND VFEU2.CandidateID = USC2.CandidateId
    AND USC1.Party <> USC2.Party
    AND S.city_code = C.city_code;
/*Question 36*/
SELECT S.Fname,
    S.LName
FROM Student AS S,
    Worked_at AS W,
    Studied_Abroad AS SA
WHERE S.StuID = W.StuID
    AND S.StuID = SA.StuID
    AND W.Position LIKE "%Intern%"
    AND (NOT W.Start_Date > SA.End_Date)
    AND (NOT SA.Start_Date > W.End_Date);
/*Question 37*/
SELECT S.Fname,
    S.LName
FROM Student AS S,
    Worked_at AS W1,
    Worked_at AS W2
WHERE S.StuID = W1.StuID
    AND S.StuID = W2.StuID
    AND W1.Position LIKE "%Intern%"
    AND W2.Position LIKE "%Intern%"
    AND W1.Position <> W2.Position
    AND NOT (
        W1.Start_Date > W2.End_Date
        OR W2.Start_Date > W1.End_Date
    );
/*Question 40*/
SELECT S.Fname,
    S.LName,
    W.Company,
    W.Start_Date,
    W.End_Date,
    DATEDIFF(W.End_Date, W.Start_Date) + 1 AS TotalDays
FROM Student AS S,
    Worked_at AS W
WHERE S.StuID = W.StuID
    AND W.Position LIKE "%Intern%";
/*Question 41*/
SELECT S.Fname,
    S.LName,
    W.Company,
    DATEDIFF(W.End_Date, W.Start_Date) + 1 AS TotalDays
FROM Student AS S,
    Worked_at AS W
WHERE S.StuID = W.StuID
    AND W.Position LIKE "%Intern%"
HAVING TotalDays = (
        SELECT MAX(M.TotalDays)
        FROM (
                SELECT S.Fname,
                    S.LName,
                    W.Company,
                    W.Start_Date,
                    W.End_Date,
                    DATEDIFF(W.End_Date, W.Start_Date) + 1 AS TotalDays
                FROM Student AS S,
                    Worked_at AS W
                WHERE S.StuID = W.StuID
                    AND W.Position LIKE "%Intern%"
            ) AS M
    );
/*Question 42*/
SELECT S.Fname,
    S.LName,
    D.dorm_name
FROM Student AS S,
    Lives_in AS L,
    Dorm AS D
WHERE S.StuID = L.stuid
    AND L.dormid = D.dormid
    AND S.StuID IN (
        SELECT L1.stuid
        FROM Lives_in AS L1,
            Lives_in AS L2,
            Has_Pet AS HP,
            Has_Allergy AS HA,
            Pet AS P
        WHERE HP.StuID = L2.stuid
            AND L1.dormid = L2.dormid
            AND HA.StuID = L1.stuid
            AND HP.PetID = P.PetID
            AND HA.Allergy = P.PetType
    );
/*Question 43*/
SELECT S2.Fname,
    S2.LName,
    P.PetName,
    S1.Fname,
    S1.LName
FROM Student AS S1,
    Student AS S2,
    Lives_in AS L1,
    Lives_in AS L2,
    Loves AS LV1,
    Loves AS LV2,
    Has_Pet AS HP,
    Pet AS P
WHERE LV1.WhoLoves = S1.StuID
    AND LV1.WhoIsLoved = S2.StuID
    AND LV2.WhoLoves = S2.StuID
    AND LV2.WhoIsLoved = S1.StuID
    AND S1.StuID = L1.stuid
    AND L1.dormid = L2.dormid
    AND L2.stuid = HP.StuID
    AND HP.PetID = P.PetID
    AND S2.Fname = P.PetName;
/*Question 44*/
SELECT S.Fname,
    S.LName,
    S.Age,
    P.PetName,
    P.PetAge
FROM Pet AS P,
    Has_Pet AS HP,
    Student AS S
WHERE P.PetType = "Dog"
    AND HP.StuID = S.StuID
    AND HP.PetID = P.PetID
    AND P.PetAge = (
        SELECT MAX(P.PetAge)
        FROM Pet AS P
        WHERE P.PetType = "Dog"
    );
/*Question 45*/
SELECT DISTINCT S1.Fname,
    S1.LName,
    D1.dorm_name,
    L1.room_number,
    S2.Fname,
    S2.LName,
    D2.dorm_name,
    L2.room_number
FROM Student S1,
    Student S2,
    Has_Pet AS HP1,
    Has_Pet AS HP2,
    Pet AS P1,
    Pet AS P2,
    Lives_in AS L1,
    Lives_in AS L2,
    Dorm AS D1,
    Dorm AS D2
WHERE S1.StuID = HP1.StuID
    AND S2.StuID = HP2.StuID
    AND HP1.PetID = P1.PetID
    AND HP2.PetID = P2.PetID
    AND (
        (
            P1.PetType = "Dog"
            AND P2.PetType = "Cat"
        )
        OR (
            P1.PetType = "Parrot"
            AND P2.PetType = "Cat"
        )
    )
    AND S1.StuID = L1.stuid
    AND S2.StuID = L2.stuid
    AND L1.dormid = D1.dormid
    AND L2.dormid = D2.dormid;
/*Question 46*/
SELECT D.dorm_name,
    COUNT(DISTINCT room_number),
    D.student_capacity
FROM Lives_in AS L,
    Dorm AS D
WHERE D.dormid = L.dormid
GROUP BY L.dormid;
/*Question 47*/
SELECT D.dorm_name,
    COUNT(DISTINCT L.room_number)
FROM Lives_in AS L,
    Dorm AS D,
    Has_Pet AS HP
WHERE L.stuid = HP.StuID
    AND D.dormid = L.dormid
GROUP BY L.dormid;
/*Question 48*/
SELECT D.dorm_name,
    IFNULL(M.Number, 0),
    IFNULL(M.Percentage, 0)
FROM Dorm AS D
    LEFT JOIN (
        SELECT D.dorm_name,
            COUNT(HP.PetID) AS Number,
            COUNT(DISTINCT L.room_number) / M.TotalRooms AS Percentage
        FROM Lives_in AS L,
            Dorm AS D,
            Has_Pet AS HP,
            (
                SELECT L.dormid,
                    COUNT(DISTINCT L.room_number) AS TotalRooms
                FROM Lives_in AS L,
                    Dorm AS D
                WHERE L.dormid = D.dormid
                GROUP BY D.dormid
            ) AS M
        WHERE L.stuid = HP.StuID
            AND D.dormid = L.dormid
            AND L.dormid = M.dormid
        GROUP BY M.dormid
    ) AS M ON D.dorm_name = M.dorm_name;
/*Question 49*/
/*Q:List the name and dorm name of students who test positive in CovidDiagnosis and vote for Donald Trump in 2016 but vote for Joe Biden in 2020*/
SELECT S.Fname,
    S.LName,
    D.dorm_name
FROM Student AS S,
    VotedForElectioninUS AS VFEU1,
    VotedForElectioninUS AS VFEU2,
    USCandidate AS USC1,
    USCandidate AS USC2,
    CovidDiagnosis AS CD,
    Dorm AS D,
    Lives_in AS L
WHERE S.StuID = VFEU1.StuID
    AND S.StuID = VFEU2.StuID
    AND VFEU1.CandidateID = USC1.CandidateID
    AND VFEU1.Year = 2016
    AND USC1.CandidateName = "Donald Trump"
    AND VFEU2.CandidateID = USC2.CandidateID
    AND VFEU2.Year = 2020
    AND USC2.CandidateName = "Joe Biden"
    AND S.StuID = CD.StuID
    AND CD.TestResult = "Positive"
    AND L.stuid = S.StuID
    AND L.dormid = D.dormid;