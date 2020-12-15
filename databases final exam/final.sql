SELECT P.Country
FROM POLITICIAN AS P
GROUP BY P.Country
HAVING AVG(Age) =
SELECT MAX(AvgAge)
FROM (
        SELECT AVG(Age) AS AvgAge
        FROM POLITICIAN
        GROUP BY Country
    ) AS M
    /*   List all countries that do not border Mexico or Canada directly, but border a country that borders Mexico or Canada.
     */
SELECT B1.Country
FROM BORDERS AS B1,
    (
        SELECT B.Country1
        FROM BORDERS AS B
        WHERE B.Country2 = 'Mexico'
            OR B.Country2 = 'Canada'
    ) AS M
WHERE (B1.Country2 IN M)
    AND (B1.Country1 NOT IN M);
/*(c) (5 points) In a single table, list the names of all continents associated with the names of the country with the smallest population in that continent (e.g. )*/
SELECT continent,
    MIN(population) AS MinPop
FROM COUNTRY AS C
GROUP BY continent
)