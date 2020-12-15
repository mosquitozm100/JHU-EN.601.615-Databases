# Databases hw4

## Mou Zhang

## (1)

### (1a)

$$
\Pi_{Lanme}(\sigma_{Budget > 50 \wedge Sex = 'M" \wedge hobby='Yodeling' \wedge Budeget > 50}((Employee \bowtie_{DNO = DNO} Department \bowtie_{ESSN = ESSN} WorksON \bowtie_{PNUM = PNUM}Project))
)
$$

<img src="/Users/mouzhang/Desktop/截屏2020-12-13 16.09.37.png" alt="截屏2020-12-13 16.09.37" style="zoom:50%;" />

### (1b)

$$
\Pi_{LName, DNO} (\sigma_{Fname = 'F16Engine' \wedge Sex = 'M'}(Employee \bowtie_{DNO = DNO} Department \bowtie_{SSN = SSN} WorksON \bowtie_{PNUM = PNUM} Project))
$$

## ![截屏2020-12-13 16.09.02](/Users/mouzhang/Library/Application Support/typora-user-images/截屏2020-12-13 16.09.02.png)

## (2)

### （2a)

| $T_0$ | $T_1$ |
| ---| --|
|read_item(A)<br>read_item(B) <br>if A=0 then B :=B+1<br>write_item(B)<br><br><br><br><br> | <br/><br/><br/><br/>read_item(B)<br>read_item(A)<br>if B=0 then A:=A+1<br>write_item(A)<br> |

### (2b)

| $T_0$ | $T_1$ |
| ---| --|
|read_item(A) |  |
|read_item(B) |  |
|| read_item(B) |
|| read_item(A) |
|if A=0 then B :=B+1 | |
|write_item(B) | |
|| if B=0 then A:=A+1|
| | write_item(A) |

## (3)

No, It is not conflict serializable. 

<img src="/Users/mouzhang/Desktop/截屏2020-12-13 14.57.49.png" alt="截屏2020-12-13 14.57.49" style="zoom:50%;" />

As is shown in the precedence graph, there are cycles in the graph, means that it is not conflict serializable.

## (4)

Yes, it is conflict serializable.

![image-20201212205627300](/Users/mouzhang/Library/Application Support/typora-user-images/image-20201212205627300.png)

As is shown in the precedence graph, there are no cycles in the graph, So we can use topo sort to give the procedures an order: T2 -> T0 -> T1. The equivalent serial schedule is shown as below.

| $T_0$                                                        | $T_1$                                                        | $T_2$                                                        |
| ------------------------------------------------------------ | :----------------------------------------------------------- | ------------------------------------------------------------ |
| <br><Br><br><br>read_item(X)<br>write_item(X) <br>read_item(Y)<br>write_item(Y)<br><br><Br><br><br><br> | <br/><br/><br/><br/><br/><br/><br/><br/><br/>read_item(Z)<br/>read_item(Y)<br/>write_item(Y)<br/>read_item(X)<br/>write_item(X)<br> | read_item(Y)<br>read_item(Z)<br/>write_item(Y)<br/>write_item(Z)<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/> |

## (5)

No, it is not conflict serializable.

## (6)

Yes, it is conflict serializable.

The valid serial schedule should be like T4 -> T5 -> T1 -> T2 -> T3.

## (7)

### (a)

Process the query at the 'Boca' plant locally

###(b)

Process the query at the New York office

### (c)

Process the queries at plant location of Toronto, Edmonton, Vancouver, Montreal separetely

### (d)

Process the query at the New York office.

## (8)

### (a)

First find the location of all plants containing machine number 1130 from MACHINE at the Armonk site. Then for each location found, let them find all employees info locally.

### (b)

First find the location of all plants containing machine whosetype is 'Milling Machine' from MACHINE at the Armonk site. Then for each location found, let them find all employees info locally.

### (c)

Find all machines whose PlantLocatiion is Almaden plant at the Armonk site.

### (d)

There are two cases: 

1. the number of contents in MACHINE table is bigger than the number of content in EMPLOYEE

Gather the EMPLOYEE table  from each location to the Armonk site and calculate the join there.

2. the number of contents in MACHINE table is smaller than the number of content in EMPLOYEE

Send the MACHINE table separately to each location and every location only receives its own part of the MACHINE table with its locatimon. Then do the join locally at every location.

## (9)

JOIN:

| A    | B    | C    | D    | E    |
| ---- | ---- | ---- | ---- | ---- |
| 6    | 4    | 3    | 4    | 3    |
| 2    | 3    | 4    | 5    | 6    |
| 2    | 3    | 4    | 7    | 9    |

SEMIJOIN:

| C    | D    | E    |
| ---- | ---- | ---- |
| 3    | 4    | 3    |
| 4    | 5    | 6    |

## (10)

The hash function should fit the memory. 

## (11)

Adding all attribute of A which does not find a match with B to the hash table with its B set as NULL. 

## (12)

Q1: select * from stat_db;

Q2: select * from stat_db where name != target_name;

Q3: Q1 - Q2

## (13)

R1 $\cap$ R2 = A

Since we have $A \rightarrow BC$, we know that $A \rightarrow ABC$, so $R1 \cap R2 \rightarrow R1$. Then according to the defination, this is a lossless-join decomposition.

## (14)

A+ -> ABCDE

B+ -> BD

C+ -> C

D+ -> D

E+ -> ABCDE

## (15)

$A \rightarrow BC$

$CD \rightarrow E$

$B \rightarrow D$

$E \rightarrow A$

## (16)

Since we have, $B \rightarrow D$, $B^+ = (BD)$

## (17)

The pseudotransitivity rule can be described as below:

If $\alpha \rightarrow \beta$ holds and $\gamma\beta \rightarrow \delta$ holds, then $\alpha \gamma \rightarrow \delta$.

Now we want to prove this rule. From Armstrong's axioms, first from $\alpha \rightarrow \beta$, we have $\alpha \gamma \rightarrow \beta \gamma$ (augmentation). Then since we have $\beta \gamma \rightarrow \delta$, we can combine this with  $\alpha \gamma \rightarrow \beta \gamma$, and get $\alpha \gamma \rightarrow \delta$ (transitivity).  Thus we have proved the pseudotransitivity rule.

## (18)

select * from R as r1, R as r2 where r1.b = r2.b and r1.c != r2.c

This query should return an empty set

## (19)

create assertion pseudotransitivity check(

no exists(select * from R as r1, R as r2 where r1.b = r2.b and r1.c != r2.c))

## (20)

It is not a dependency preserving decomposition becuase you can not check $CD \rightarrow E$ and $B \rightarrow D$ without computing 

$r1 \bowtie r2$.

## （21）

R = {A, B, C, D}

F = {A $\rightarrow$ B, B $\rightarrow$ C, C $\rightarrow$ D}

key = {A}