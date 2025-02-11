-- The PADS

SELECT CONCAT(Name,"(", LEFT(Occupation,1),")") FROM OCCUPATIONS ORDER BY Name;

SELECT CONCAT("There are a total of ",
               COUNT(Occupation), " ",LOWER(Occupation),"s.") 
  FROM OCCUPATIONS 
  GROUP BY Occupation
  ORDER BY COUNT(Occupation), Occupation;

-- Binary Tree Nodes 
 -- Method 1:
  SELECT N, 
  (CASE WHEN P IS NULL THEN "Root"
   WHEN N IN (SELECT P FROM BST GROUP BY P HAVING COUNT(N)=2) THEN "Inner" 
   ELSE "Leaf" END) AS Type
   FROM BST ORDER BY N
 -- Method 2:
  SELECT N, IF(P IS NULL, "Root", 
               IF((N IN (SELECT P FROM BST GROUP BY P HAVING COUNT(N)=2)), "Inner", "Leaf")) 
                         AS Type 
                          FROM BST 
                         ORDER BY N

-- New Companies
                        
SELECT C.company_code, C.founder,
 LM.LMN, SM.SMN, M.MN, E.EN
                         FROM Company AS C
 LEFT JOIN (SELECT company_code,COUNT(DISTINCT lead_manager_code) AS LMN
            FROM Lead_Manager
            GROUP BY company_code) LM
      ON C.company_code=LM.company_code
  JOIN (SELECT company_code,COUNT(DISTINCT senior_manager_code) AS SMN
       FROM Senior_Manager
       GROUP BY company_code) SM
    ON C.company_code=SM.company_code
  JOIN (SELECT company_code,COUNT(DISTINCT manager_code) AS MN
        FROM Manager
        GROUP BY company_code) M
     ON C.company_code=M.company_code
  JOIN (SELECT company_code,COUNT(DISTINCT employee_code) AS EN
        FROM Employee
        GROUP BY company_code) E
    ON C.company_code=E.company_code
ORDER BY  C.company_code

-- Top Competitors                         
SELECT T2.hacker_id, H.name
     FROM 
         (SELECT hacker_id, COUNT(hacker_id) AS num
          FROM
          (SELECT S.*, D.score AS full_score 
                  FROM Submissions AS S
           JOIN Challenges AS C ON S.challenge_id=C.challenge_id
           JOIN Difficulty AS D ON C.difficulty_level=D.difficulty_level) T
          WHERE score=full_score
          GROUP BY hacker_id) T2
      JOIN Hackers AS H
      ON T2.hacker_id=H.hacker_id
      WHERE T2.num>1
ORDER BY T2.num DESC, T2.hacker_id 

-- Weather Observation Station 18                         
SELECT ROUND((ABS(c-a)+ABS(d-b)),4) AS distance
  FROM (SELECT MIN(LAT_N) AS a, MIN(LONG_W) AS b, 
               MAX(LAT_N) AS c, MAX(LONG_W) AS d 
        FROM STATION) Tmp                         

                         
-- Weather Observation Station 19                         
SELECT ROUND(SQRT(POWER((b-a),2)+POWER((d-c),2)),4) AS distance
  FROM (SELECT MIN(LAT_N) AS a, MAX(LAT_N) AS b, 
                MIN(LONG_W) AS c, MAX(LONG_W) AS d  
          FROM STATION) Tmp

-- Weather Observation Station 20
-- SELECT ROUND(LAT_N,4) FROM
-- (SELECT LAT_N, ROW_NUMBER() OVER(ORDER BY LAT_N) AS rn3
-- FROM STATION 
-- WHERE rn3=
-- (SELECT (CASE WHEN MAX(rn)%2!=0 THEN MAX(rn)/2
--                  ELSE FLOOR(MAX(rn)/2)+1 END ) AS rn2
-- (SELECT LAT_N, ROW_NUMBER() OVER(ORDER BY LAT_N) AS rn FROM STATION) T1))T3
-- -- WHERE ROW_NUMBER=(SELECT COUNT(1)/2+1 FROM STATION)
