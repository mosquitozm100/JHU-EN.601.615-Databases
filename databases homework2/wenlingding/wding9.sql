# 1. List the names of all pairs of students who are from the same city and like each other but don’t love each other.

select T.Fname, T.Lname, S.Fname, S.Lname 
from Student as T, Student as S 
where T.City_Code = S.City_Code and
S.StuID in (select WhoIsLiked from Likes where WhoLikes = T.StuID) 
and S.StuID not in (select WhoIsLoved from Loves where WhoLoves = T.StuID)
and T.StuID in (select WhoIsLiked from Likes where WhoLikes = S.StuID) 
and T.StuID not in (select WhoIsLoved from Loves where WhoLoves = S.StuID)
and T.StuID < S.StuID;

# 2. List the name of the car-owning student in the database who owns the lowest MPG vehicle (of all the student-owned cars), along with the Manufacturer, Model, and MPG of that car
 
select S.Fname, S.Lname, C.CarManufacturer, C.CarModel, C.miles_per_gallon
from Student as S, Car as C, Car_Ownership as O
where C.miles_per_gallon = (select min(miles_per_gallon) from Car)
and O.CarID = C.CarID and S.StuID = O.StuID;

# 3. List the name(s), age and major of student(s) who own every model of car manufactured by Nissan listed in the database. You cannot assume that Nissan only manufactures 3 models, as this can change.

select distinct S.Fname, S.Lname, S.Age, S.major
from Student as S, Car_Ownership as O
where S.StuID = O.StuID and not exists(
(select distinct CarModel from Car where CarManufacturer = "Nissan")
except
(select C.CarModel 
	from Car as C, Car_Ownership as O1
	where C.CarID = O1.CarID and O1.StuID = O.StuID)
);

# 4. List the names of students who live in a dorm and own more than one car.

select S.Fname, S.Lname
from Student as S, Lives_in as L
where S.StuID = L.StuID and exists(
select count(O.CarID)
from Car_Ownership as O
where S.StuID = O.StuID
group by O.StuID
having count(O.CarID) > 1
);


# 5. List the names of students who live in a dorm and don’t own a car but own a pet.  

select S.Fname, S.Lname
from Student as S, Lives_in as L
where S.StuID = L.StuID and not exists(
select O.CarID
from Car_Ownership as O
where S.StuID = O.StuID
)
and exists(
select P.PetID
from Has_Pet as P
where S.StuID = P.StuID
);

# 7. What is the minimum, maximum and average MPG of all models of Porsche listed in the database?

select min(C.miles_per_gallon), max(C.miles_per_gallon), avg(C.miles_per_gallon)
from Car as C
where C.CarManufacturer = "Porsche";

# 8. What is the minimum, maximum and average age of students who live in the JHU dorms and do not own a car?

select min(S.Age), max(S.Age), avg(S.Age)
from Student as S, Lives_in as L
where S.StuID = L.StuID and not exists(
select O.CarID
from Car_Ownership as O
where S.StuID = O.StuID
);

# 10. What is the average age of students who participate in more than 2 activities?

select avg(S.Age)
from Student as S
where exists (
select distinct count(A.Actid)
from Participates_in as A
where A.StuID = S.StuID
group by A.StuID
having count(A.Actid) > 2
);

# 11. How many students participate in the most popular student activity, and what is the name of this activity?

select A.actid, A.activity_name, count(P1.StuID)
from Participates_in as P1, Activity as A
where A.Actid = P1.Actid
group by P1.Actid
having count(P1.StuID) = (
select max(Act_count.Stud_count)
from (
select count(P1.StuID) as Stud_count
from Participates_in as P1
group by P1.Actid
) as Act_count);

# 12. List the names of all activities with no student participants which do have faculty participants.

select distinct A.activity_name
from Activity as A, Faculty_Participates_in as FP
where FP.actid = A.actid and not exists(
select SP.actid
from Participates_in as SP
where FP.actid = SP.actid
);

# 13. List all students enrolled in a course with someone who is enrolled in a course with someone who is roommates with someone whose hometown is in Pennslyvania (PA) and voted for Donald Trump in 2020.

select S3.Fname, S3.Lname
from Student as S3, Enrolled_in as E3, Enrolled_in as E4
where S3.StuID = E3.StuID and E3.CID = E4.CID and E4.StuID in
(select S2.StuID
from Student as S2, Enrolled_in as E1, Enrolled_in as E2
where S2.StuID = E1.StuID and E1.CID = E2.CID and E2.StuID in 
(select S1.StuID
from Student as S1, Lives_in as L1, Lives_in as L2
where S1.StuID = L1.StuID and L1.dormid = L2.dormid and L1.room_number = L2.room_number and L2.StuID in 
(select S.StuID
from Student as S, City as C, VotedForElectioninUS as V, USCandidate as Can
where S.City_code = C.City_code and C.State = "PA" and V.StuID = S.StuID and Can.CandidateId = V.CandidateId and Can.CandidateName = "Donald Trump" and V.Year = 2020)));

# 14. List the names of students who share at least one activity with their advisor; exclude advisors who do not teach any classes. List the name of the advisor in addition to that of the student.

select distinct S.Fname, S.Lname, F.Fname, F.Lname
from Student as S, Faculty as F
where exists (
select SP.actid
from Participates_in as SP, Faculty_Participates_in as FP
where S.StuID = SP.StuID and S.advisor = FP.FacID and SP.actid = FP.actid and F.FacID = FP.FacID 
and FP.FacID in (select C.Instructor from Course as C)
);

# 15. Find all pairs of students who are roommates and from different countries. List each pair only once. (List their names).

select distinct S1.Fname, S1.Lname, S2.Fname, S2.Lname
from Student as S1, Student as S2, Lives_in as L1, Lives_in as L2
where S1.StuID = L1.StuID and S2.StuID = L2.StuID and L1.DormID = L2.DormID and L1.room_number = L2.room_number and not exists(
select C1.City_Code
from City as C1, City as C2 
where S1.City_Code = C1.City_Code and S2.City_Code = C2.City_Code and C1.country = C2.country
) and S1.StuID < S2.StuID;

# 16. List the dormitory whose residents have the highest gradepoint average.

select D.dorm_name, D.dormid
from Lives_in as L, Dorm as D, (
	select S.StuID, sum(C.Credits * G.gradepoint)/sum(C.Credits) as sum_grad
	from Student as S, Course as C, Gradeconversion as G, Enrolled_in as E
	where E.StuID = S.StuID and E.Grade = G.lettergrade and E.CID = C.CID
	group by S.StuID
	) as Stu_grad
where Stu_grad.StuID = L.StuID and D.dormid = L.dormid
group by L.dormid
having avg(Stu_grad.sum_grad) = 
(select max(Dorm_grad.dorm_sum)
from 
(
select L.dormid, avg(Stu_grad.sum_grad) as dorm_sum
from Lives_in as L, (
	select S.StuID, sum(C.Credits * G.gradepoint)/sum(C.Credits) as sum_grad
	from Student as S, Course as C, Gradeconversion as G, Enrolled_in as E
	where E.StuID = S.StuID and E.Grade = G.lettergrade and E.CID = C.CID
	group by S.StuID
	) as Stu_grad
where Stu_grad.StuID = L.StuID
group by L.dormid
)as Dorm_grad
);

# 17
# 17.1

drop table if exists Baltimore_distance;
create table Baltimore_distance (
  city1_code varchar(3),
  city2_code varchar(3),
  distance INTEGER
);

insert into Baltimore_distance
	select distinct D1.city2_code, D2.city2_code, D1.distance + D2.distance
	from Direct_distance as D1, Direct_distance as D2
	where D1.city1_code = "BAL" and D2.city1_code = "BAL" and D1.city2_code != D2.city2_code and D1.city2_code < D2.city2_code;

# 17.2

drop table if exists Rectangular_distance;
create table Rectangular_distance (
  city1_code varchar(3),
  city2_code varchar(3),
  distance FLOAT
);

insert into Rectangular_distance
	select distinct C1.city_code, C2.city_code, power(power(70 * C1.latitude - 70 * C2.latitude, 2) + power(70 * C1.longitude - 70 * C2.longitude, 2) , 1/2)
	from City as C1, City as C2
	where C1.city_code < C2.city_code;

# 17.3

drop table if exists All_distances;
create table All_distances (
  city1_code varchar(3),
  city2_code varchar(3),
  direct_distance INTEGER,
  baltimore_distance INTEGER,
  rectangular_distance FLOAT
);

insert into All_distances
	select distinct D.city1_code, D.city2_code, D.distance, BD.distance, RD.distance
	from Direct_distance as D, Baltimore_distance as BD, Rectangular_distance as RD
	where D.city1_code = BD.city1_code and D.city1_code = RD.city1_code and D.city2_code = BD.city2_code and D.city2_code = RD.city2_code;

# 17.4

drop table if exists Best_distance;
create table Best_distance (
  city1_code varchar(3),
  city2_code varchar(3),
  distance FLOAT
);

insert into Best_distance
	select distinct D.city1_code, D.city2_code, D.direct_distance
	from All_distances as D;

# 18. List each city that is home to at least 2 students, and how many students live there

select S.City_Code, count(S.StuID)
from Student as S
group by S.City_Code
having count(S.StuID) > 1;

# 19. Find all students living in dorms with fewer than 300 residents, whose homes are within 100 miles of someone else in the dorm they live in. List the name and city, state and country of origin for each of these students.

select distinct S.Fname, S.Lname, C.City_name, C.State, C.country
from Student as S, City as C, Lives_in as L, Dorm as D
where S.StuID = L.StuID and D.dormid = L.dormid and D.Student_capacity <= 300 and S.City_code = C.City_code
and exists(
select S1.StuID
from Student as S1, Lives_in as L1, Best_distance as DD
where L1.StuID = S1.StuID and L1.dormid = D.dormid and S1.StuID != S.StuID and DD.City1_code = S.City_Code and DD.City2_code = S1.City_Code and DD.Distance <= 100
);

# 20. For every country, list the student(s) whose homes are in the city furthest from Baltimore

select distinct S.Lname, S.Fname, C.country, D.Distance
from Student as S, City as C, Best_distance as D, 
(select C.country, max(D.Distance) as max_distance
from Student as S, City as C, Best_distance as D
where S.City_Code = C.City_Code and ((D.City1_code = "BAL" and D.City2_code = S.City_Code) or (D.City2_code = "BAL" and D.City1_code = S.City_Code))
group by C.country) as Country_distance
where ((D.City1_code = "BAL" and D.City2_code = S.City_Code) or (D.City2_code = "BAL" and D.City1_code = S.City_Code)) 
and S.City_Code = C.City_Code and D.Distance = Country_distance.max_distance and C.country = Country_distance.country;

# 21. List the name of the activity whose participants’ homes have the greatest average distance from Baltimore.

select Avg_distance.activity_name
from 
	(select A.activity_name, avg(D.distance) as avg_dis_actid
	from Activity as A, Participates_in as P, Student as S, Best_distance as D
	where A.actid = P.actid and P.StuID = S.StuID and S.City_Code = D.City2_code and D.City1_code = "BAL"
	group by P.actid) as Avg_distance
where Avg_distance.avg_dis_actid = (
	select max(R.avg_dis_actid_1)
	from (
	select avg(D1.distance) as avg_dis_actid_1
	from Activity as A1, Participates_in as P1, Student as S1, Best_distance as D1
	where A1.actid = P1.actid and P1.StuID = S1.StuID and S1.City_Code = D1.City2_code and D1.City1_code = "BAL"
	group by P1.actid) as R
);

# 22. List the names and ages of all female students minoring in a department in the engineering school and taught by a female professor whose primary appointment is in the engineering school.

select S.Fname, S.Lname, S.Age
from Student as S, Minor_in as M, Department as D
where S.StuID = M.StuID and M.DNO = D.DNO and D.Division = "EN" and S.Sex = "F" and exists (
	select F.FacID
	from Course as C, Enrolled_in as E, Faculty as F, Member_of as Member, Department as D1
	where E.StuID = S.StuID and E.CID = C.CID and C.Instructor = F.FacID and F.Sex = "F" and C.Instructor = Member.FacID and Member.Appt_Type = "Primary" and Member.DNO = D1.DNO and D1.Division = "EN"
);

# 23. List the names and student ID numbers of all students who are enrolled in every course taught by Paul Smolensky.

select S.Fname, S.Lname, S.StuID
from Student as S
where not exists (
	(select distinct C.CID
	from Course as C, Faculty as F
	where C.Instructor = F.FacID and F.Lname = "Smolensky" and F.Fname = "Paul")
	except
	(select E1.CID
	from Enrolled_in as E1, Course as C1, Faculty as F1
	where S.StuID = E1.StuID and E1.CID = C1.CID and C1.Instructor = F1.FacID and F1.Lname = "Smolensky" and F1.Fname = "Paul")
);

# 24. List the names and ID numbers of all students who are enrolled in a class with a student who is enrolled in a class that Linda Smith is enrolled in, and also lives in the same state that Linda Smith lives in and also voted for the same president that Linda Smith voted for in both 2016 and 2020.

select distinct S.Fname, S.Lname, S.StuID
from Student as S, Student as SL, City as C1, City as C2, VotedForElectioninUS as V1, VotedForElectioninUS as V2, VotedForElectioninUS as V3, VotedForElectioninUS as V4, USCandidateFor as CF1, USCandidateFor as CF2, USCandidateFor as CF3, USCandidateFor as CF4
where S.City_code = C1.City_code and SL.Fname = "Linda" and SL.Lname = "Smith" and SL.City_code = C2.City_Code and C1.State = C2.State
and V1.StuID = S.StuID and V2.StuID = SL.StuID and V1.Year = 2016 and V2.Year = 2016 and V1.CandidateID = V2.CandidateID and V1.CandidateID = CF1.CandidateID and V2.CandidateID = CF2.CandidateID and CF1.Office = "President" and CF2.Office = "President" and CF1.Year = 2016 and CF2.Year = 2016
and V3.StuID = S.StuID and V4.StuID = SL.StuID and V3.Year = 2020 and V4.Year = 2020 and V3.CandidateID = V4.CandidateID and V3.CandidateID = CF3.CandidateID and V4.CandidateID = CF4.CandidateID and CF3.Office = "President" and CF4.Office = "President" and CF3.Year = 2020 and CF4.Year = 2020
and exists (
	select E.CID
	from Enrolled_in as E, Enrolled_in as EE
	where S.StuID = E.StuID and E.CID = EE.CID and EE.StuID in (
select S1.StuID
from Student as S1
where exists (
select E1.CID
from Enrolled_in as E1, Enrolled_in as E2, Student as S2
where E1.CID = E2.CID and E1.StuID = S1.StuID and E2.StuID = S2.StuID and S2.Fname = "Linda" and S2.Lname = "Smith")
)
);

# 25. List the names of courses that are enrolled with students who are not a member of any club, who have no allergies, and who likes people who is both in a club and has an allergy

select distinct C.CName
from Course as C, Enrolled_in as E
where E.CID = C.CID
and exists(
select distinct E1.StuID
from Enrolled_in as E1
where E.StuID = E1.StuID and E1.StuID not in (
	select distinct M.StuID
	from Member_of_club as M)
)
and exists (
select distinct E2.StuID
from Enrolled_in as E2
where E.StuID = E2.StuID and E2.StuID not in (
	select distinct A.StuID
	from Has_Allergy as A)
)
and exists(
select distinct L.WhoLikes
from Likes as L
where L.WhoLikes = E.StuID and L.WhoIsLiked in (
	select distinct M.StuID
	from Member_of_club as M) and L.WhoIsLiked in (
	select distinct A.StuID
	from Has_Allergy as A)
);

# 26. List the first and last name and dorm name of any student with at least one conduct violation, and the total number of his/her violations.

select S.Fname, S.Lname, D.Dorm_name, count(V.StuID)
from Student as S, Dorm as D, ConductViolation as V
where V.StuID = S.StuID and V.Dormid = D.Dormid
group by V.StuID;

# 27. List the first and last name and dorm name the student with the most total conduct violations, along with that total. If there are multiple tied students tied, list all.

select S1.Fname, S1.Lname, D1.Dorm_name, count(V1.StuID) as Vio_count_1
from Student as S1, Dorm as D1, ConductViolation as V1
where V1.StuID = S1.StuID and V1.Dormid = D1.Dormid
group by V1.StuID
having Vio_count_1 = 
(select max(VC.Vio_count)
from
(select S.Fname, S.Lname, D.Dorm_name, count(V.StuID) as Vio_count
from Student as S, Dorm as D, ConductViolation as V
where V.StuID = S.StuID and V.Dormid = D.Dormid
group by V.StuID) as VC);

# 29. List the name and department of classes where the enrolled students have the most conduct violations (of any type).

select distinct C.CName, DD.Division, DD.DName
from Course as C, Department as DD, Enrolled_in as E
where C.CID = E.CID and DD.DNO = C.DNO and 
E.StuID in 
(select Stud_List.StuID
from 
(select S1.StuID, count(V1.StuID) as Vio_count_1
from Student as S1, ConductViolation as V1
where V1.StuID = S1.StuID
group by V1.StuID
having Vio_count_1 = 
(select max(VC.Vio_count)
from
(select count(V.StuID) as Vio_count
from Student as S, ConductViolation as V
where V.StuID = S.StuID
group by V.StuID) as VC)) as Stud_List);

# 30. List the names of student organizations whose members collectively have over 3 conduct violations.

select CCount.ClubName
from
(select C.ClubName, C.ClubID, count(V.StuID) as Vio_count
from Club as C, ConductViolation as V, Member_of_club as M
where M.ClubID = C.ClubID and V.StuID = M.StuID
group by C.ClubID
having Vio_count > 3) as CCount;

# 31. List the names of all students who live in the same dorm room but voted for different candidates for US president in 2020, and also list the names of the presidential candidates that each voted for. Only include roommates who both voted for president in 2020 and only list each pair once.

select distinct S1.Fname, S1.Lname, S2.Fname, S2.Lname, C1.CandidateName, C2.CandidateName
from Student as S1, Student as S2, USCandidate as C1, USCandidate as C2, Lives_in as L1, Lives_in as L2, VotedForElectioninUS as V1, VotedForElectioninUS as V2, USCandidateFor as CF1, USCandidateFor as CF2 
where S1.StuID = L1.StuID and S2.StuID = L2.StuID and L1.DormID = L2.DormID and L1.room_number = L2.room_number
and V1.StuID = S1.StuID and V2.StuID = S2.StuID and V1.Year = 2020 and V2.Year = 2020 and V1.CandidateID != V2.CandidateID and CF1.CandidateID = V1.CandidateID and CF2.CandidateID = V2.CandidateID and CF1.Office = "President" and CF2.Office = "President" and CF1.Year = 2020 and CF2.Year = 2020
and C1.CandidateID = V1.CandidateID and C2.CandidateID = V2.CandidateID and S1.StuID < S2.StuID;

# 32. List the name of the dorm with the largest total number of students who have voted for Donald Trump for US president in 2020 (along with that total number of students).

select D.Dorm_name, count(distinct V.StuID) as dorm_count
from Dorm as D, Lives_in as L, VotedForElectioninUS as V, USCandidate as C, USCandidateFor as CF
where V.StuID = L.StuID and L.dormid = D.dormid and V.CandidateID = C.CandidateID and V.Year = 2020 and C.CandidateName = "Donald Trump" and CF.CandidateID = V.CandidateID and CF.Office = "President" and CF.Year = 2020
group by D.dormid
having dorm_count = 
(select max(Dorm_vote.dorm_count)
from
(select count(distinct V.StuID) as dorm_count
from Dorm as D, Lives_in as L, VotedForElectioninUS as V, USCandidate as C, USCandidateFor as CF
where V.StuID = L.StuID and L.dormid = D.dormid and V.CandidateID = C.CandidateID and V.Year = 2020 and C.CandidateName = "Donald Trump" and CF.CandidateID = V.CandidateID and CF.Office = "President" and CF.Year = 2020
group by D.dormid) as Dorm_vote);

# 33. List the name of the dorm with the highest percentage of students who have voted for Donald Trump for US president in 2020 (as a percentage of the total number of students living in the dorm (NOT capacity), regardless of how many students in that dorm voted for president in 2020). For that dorm, include the number of votes for Donald Trump, the total number of students living in the dorm, and the percentage of votes for Donald Trump

select Dorm_Vote.Dorm_name, Dorm_Vote.Vote_Count / Dorm_Stud.People_Count
from
(select D.Dorm_name, count(distinct L.StuID) as Vote_Count
from Dorm as D, Lives_in as L, VotedForElectioninUS as V, USCandidate as C, USCandidateFor as CF
where L.StuID = V.StuID and D.DormID = L.Dormid and V.CandidateID = C.CandidateID and V.Year = 2020 and C.CandidateName = "Donald Trump" and CF.CandidateID = V.CandidateID and CF.Office = "President" and CF.Year = 2020
group by D.Dorm_name) as Dorm_Vote,
(select D.Dorm_name, count(distinct L.StuID) as People_Count
from Dorm as D, Lives_in as L
where D.DormID = L.Dormid
group by D.Dorm_name) as Dorm_Stud
where Dorm_Vote.Dorm_name = Dorm_Stud.Dorm_name and Dorm_Vote.Vote_Count / Dorm_Stud.People_Count = (
select max(Dorm_Vote.Vote_Count / Dorm_Stud.People_Count)
from
(select D.Dorm_name, count(distinct L.StuID) as Vote_Count
from Dorm as D, Lives_in as L, VotedForElectioninUS as V, USCandidate as C, USCandidateFor as CF
where L.StuID = V.StuID and D.DormID = L.Dormid and V.CandidateID = C.CandidateID and V.Year = 2020 and C.CandidateName = "Donald Trump" and CF.CandidateID = V.CandidateID and CF.Office = "President" and CF.Year = 2020
group by D.Dorm_name) as Dorm_Vote,
(select D.Dorm_name, count(distinct L.StuID) as People_Count
from Dorm as D, Lives_in as L
where D.DormID = L.Dormid
group by D.Dorm_name) as Dorm_Stud
where Dorm_Vote.Dorm_name = Dorm_Stud.Dorm_name);

# 34. List the names and ages of students who have voted for different candidates for US president in 2016 and 2020, as well as the names of and political parties of the candidates they voted for in each election. The student should must have voted in both elections

select distinct S.Fname, S.Lname, S.Age, C1.CandidateName, C1.Party, C2.CandidateName, C2.Party
from Student as S, USCandidate as C1, USCandidate as C2, VotedForElectioninUS as V1, VotedForElectioninUS as V2, USCandidateFor as CF1, USCandidateFor as CF2
where S.StuID = V1.StuID and S.StuID = V2.StuID and V1.Year = 2016 and V2.Year = 2020 and V1.CandidateID != V2.CandidateID and C1.CandidateID = V1.CandidateID and C2.CandidateID = V2.CandidateID
and CF1.CandidateID = V1.CandidateID and CF2.CandidateID = V2.CandidateID and CF1.Office = "President" and CF2.Office = "President" and CF1.Year = 2016 and CF2.Year = 2020;

# 35. List the names and home state of students who have voted for different political parties for US president in different years (e.g. Republican in 2016 and Democrat in 2020). Ignore years when the student didn’t vote.

select distinct S.Fname, S.Lname, C.State
from Student as S, City as C
where S.City_code = C.City_code and S.StuID in (
select V1.StuID
from USCandidate as C1, USCandidate as C2, VotedForElectioninUS as V1, VotedForElectioninUS as V2, USCandidateFor as CF1, USCandidateFor as CF2
where V1.StuID = V2.StuID and V1.CandidateID = C1.CandidateID and V2.CandidateID = C2.CandidateID and V1.Year != V2.Year and C1.Party != C2.Party
and CF1.CandidateID = V1.CandidateID and CF2.CandidateID = V2.CandidateID and CF1.Office = "President" and CF2.Office = "President" and CF1.Year != CF2.Year);

# 36. List the names of all people who worked as an Intern (Intern anywhere in his/her job name) at the same time that they have lived abroad (i.e. where the dates overlap by at least one day). For example, the two ranges 2020-06-17 through 2020-08-23 and 2020-08-21 through 2020-09-12 overlap by 3 days (8/21, 8/22 and 8/23)).

select S.Fname, S.Lname
from Student as S, Worked_at as W, Studied_Abroad as A
where S.StuID = W.StuID and W.Position like "%Intern%" and A.StuID = S.StuID and not (A.Start_Date > W.End_Date or A.End_Date < W.Start_Date);

# 37. List the names of all people who worked as an Intern (Intern anywhere in his/her job name) in at least two positions at the same time (i.e. where the dates overlap by at least one day).

select S.Fname, S.Lname
from Student as S, Worked_at as W1, Worked_at as W2
where S.StuID = W1.StuID and S.StuID = W2.StuID and W1.Position like "%Intern%" and W2.Position like "%Intern%" and W1.Position != W2.Position and not (W1.Start_Date > W2.End_Date or W1.End_Date < W2.Start_Date);

# 40. For every student internship (with Intern anywhere in the job title), list the name of the student, the company where they worked, the start and end dates of the internship and the total number of days the student worked there (including the start and end date).

select S.Fname, S.Lname, W.Company, W.Start_Date, W.End_Date, datediff(W.End_Date, W.Start_Date)
from Student as S, Worked_at as W
where S.StuID = W.StuID and W.Position like "%Intern%";

# 41. List the name of the student with the longest total internship, as well as the name of the company they were an intern for and the total number of days the student worked there. As before, an internship is a job with the word Intern anywhere in the job title

select S.Fname, S.Lname, W.Company, sum(datediff(W.End_Date, W.Start_Date)) as Day_Sum
from Student as S, Worked_at as W
where S.StuID = W.StuID and W.Position like "%Intern%"
group by S.StuID
having Day_Sum = (
select max(Day_count.Day_Sum)
from
(select S.Fname, S.Lname, W.Company, sum(datediff(W.End_Date, W.Start_Date)) as Day_Sum
from Student as S, Worked_at as W
where S.StuID = W.StuID and W.Position like "%Intern%"
group by S.StuID) as Day_count);

# 42. List the student name and dorm name of all the students who live in a dorm that has a pet living there of the same type that the student is allergic to. Assume that if a student both has a pet and lives in a dorm, that pet lives with the student in the dorm. The student and pet don’t have to live in the same room.

select S.Fname, S.Lname, D.Dorm_name
from Student as S, Dorm as D, Lives_in as L                
where S.StuID = L.StuID and D.dormid = L.dormid and exists(
select P.PetID
from Lives_in as L1, Has_Allergy as A, Has_Pet as HP, Pet as P
where A.StuID = S.StuID and L1.dormid = L.dormid and L.StuID = HP.StuID and HP.PetID = P.PetID and P.PetName = A.Allergy
);

# 43. List the names of every pair of students love each other and live with someone that has a pet with the same name as the first name of the person they love. Include the pet’s name and list the person who matches the pet’s name 1st.

select distinct S1.Fname, S1.Lname, S2.Fname, S2.Lname, P.PetName
from Loves as LV1, Loves as LV2, Student as S1, Student as S2, Dorm as D1, Dorm as D2, Lives_in as L1, Lives_in as L2, Has_Pet as HP, Pet as P
where LV1.WhoLoves = S1.StuID and LV1.WhoIsLoved = S2.StuID and LV2.WhoLoves = LV1.WhoIsLoved and LV2.WhoIsLoved = LV1.WhoLoves 
and L1.StuID = LV1.WhoLoves and L2.StuID = HP.StuID and L1.dormid = L2.dormid and L1.room_number = L2.room_number
and HP.PetID = P.PetID and P.PetName = S2.Fname

# 44. List the name and age of the student who owns the oldest dog in the database. Also include the name of the pet and the age of the pet next to the student’s name.

select S.Fname, S.Lname, S.Age, P.PetName, P.PetAge
from Student as S, Pet as P, Has_Pet as HP
where HP.StuID = S.StuID and HP.PetID = P.PetID and P.PetType = "Dog" and P.PetAge = (
select max(P.PetAge)
from Pet as P
where P.PetType = "Dog"
);

# 45. Assuming that dogs cannot live with cats, cats cannot live with parrots but parrots can live with dogs, which pair of students who own pets cannot potentially be roommates. List the student names, dorm name and dorm room number of both students, with each pair listed only once.

select distinct S1.Fname, S1.Lname, D1.dorm_name, L1.room_number, S2.Fname, S2.Lname, D2.dorm_name, L2.room_number
from Student as S1, Student as S2, Dorm as D1, Dorm as D2, Lives_in as L1, Lives_in as L2, Has_Pet as HP1, Has_Pet as HP2, Pet as P1, Pet as P2
where S1.StuID = L1.StuID and S2.StuID = L2.StuID and L1.dormid = D1.dormid and L2.dormid = D2.dormid
and HP1.StuID = S1.StuID and HP2.StuID = S2.StuID and P1.PetID = HP1.PetID and P2.PetID = HP2.PetID 
and P1.PetType = "Cat" and (P2.PetType = "Dog" or P2.PetType = "Parrot");

# 46. For each dorm, list the name of the dorm and the total number of occupied rooms in the dorm (rooms with at least one listed occupant), and the total capacity of each dorm.

select D.dorm_name, count(distinct L.room_number), D.student_capacity
from Dorm as D, Lives_in as L
where L.dormid = D.dormid
group by D.dorm_name;

# 47. For each dorm, list the name of the dorm and the total number of rooms in the dorm with at least one pet living in that room.

select D.dorm_name, count(distinct L.room_number)
from Dorm as D, Lives_in as L, Has_Pet as HP
where HP.StuID = L.StuID and L.dormid = D.dormid
group by L.dormid;

# 48. For each dorm, list the name of the dorm, the total number of pets living in the dorm, and the percentage of occupied rooms in the dorm which have at least one pet living in that room. Do not use the dorm capacity, but the total number of rooms with a listed occupant.

select D.dorm_name, count(distinct L.room_number) / Occupied_Room.Total_Occupied, count(distinct HP.PetID)
from Dorm as D, Lives_in as L, Has_Pet as HP,
(select D.dorm_name, count(distinct L.room_number) as Total_Occupied
from Dorm as D, Lives_in as L
where L.dormid = D.dormid
group by D.dorm_name) as Occupied_Room
where HP.StuID = L.StuID and L.dormid = D.dormid and Occupied_Room.dorm_name = D.dorm_name
group by L.dormid;

select D.dorm_name, count(distinct L.room_number) / Occupied_Room.Total_Occupied, count(distinct HP.PetID)
from Lives_in as L, Has_Pet as HP, 
(select D.dorm_name, count(distinct L.room_number) as Total_Occupied
from Dorm as D, Lives_in as L
where L.dormid = D.dormid
group by D.dorm_name) as Occupied_Room
where HP.StuID = L.StuID and L.dormid = D.dormid and Occupied_Room.dorm_name = D.dorm_name
group by L.dormid;

# 49. Invent a complex, interesting question of your choice using the data in the jhu.sql schema and write both a SQL and QBE query to compute the answer to your question. Grading of this question will be based as much on your creativity as the correctness of your solution.
# Q: List the name and age of students who have cat and vote for Joe Biden as president in 2020 and vote for Hillary Clinton as president in 2016, also list the dorm name for these students.

select S.Fname, S.Lname, S.Age, D.Dorm_name
from Student as S, Has_Pet as HP, Pet as P, Lives_in as L, Dorm as D, USCandidate as C1, VotedForElectioninUS as V1, USCandidate as C2, VotedForElectioninUS as V2, USCandidateFor as CF1, USCandidateFor as CF2
where S.StuID = HP.StuID and HP.PetID = P.PetID and P.PetType = "Cat" 
and S.StuID = L.StuID and L.dormid = D.dormid
and S.StuID = V1.StuID and V1.Year = 2020 and V1.CandidateID = C1.CandidateID and C1.CandidateName = "Joe Biden"
and S.StuID = V2.StuID and V2.Year = 2016 and V2.CandidateID = C2.CandidateID and C2.CandidateName = "Hillary Clinton"
and CF1.CandidateID = V1.CandidateID and CF2.CandidateID = V2.CandidateID and CF1.Office = "President" and CF2.Office = "President" and CF1.Year = 2020 and CF2.Year = 2016;


















