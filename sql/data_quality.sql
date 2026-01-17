/*=====================================================
  DATA QUALITY CHECK
=====================================================*/

--Null Key Check
SELECT COUNT(*) 
FROM dim_title 
WHERE title_id IS NULL;

--Rating Range Validation
SELECT COUNT(*)
FROM fact_title_ratings
WHERE average_rating NOT BETWEEN 0 AND 10;

--Orphan Record Check
SELECT COUNT(*)
FROM fact_title_ratings r
LEFT JOIN dim_title t
  ON r.title_id = t.title_id
WHERE t.title_id IS NULL;

