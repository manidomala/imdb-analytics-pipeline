/*=====================================================
  DATA QUALITY CHECKS
=====================================================*/

-- Null primary keys
SELECT COUNT(*) AS null_titles
FROM dim_title
WHERE title_id IS NULL;

-- Rating validation
SELECT COUNT(*) AS invalid_ratings
FROM fact_title_ratings
WHERE average_rating NOT BETWEEN 0 AND 10;

-- Orphan facts
SELECT COUNT(*) AS orphan_facts
FROM fact_title_ratings r
LEFT JOIN dim_title t
  ON r.title_id = t.title_id
WHERE t.title_id IS NULL;
