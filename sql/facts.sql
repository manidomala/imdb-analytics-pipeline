/*=====================================================
  FACT TABLES
=====================================================*/

CREATE OR REPLACE TABLE fact_title_ratings AS
SELECT
  r.tconst AS title_id,
  r.average_rating,
  r.num_votes,
  CURRENT_TIMESTAMP() AS created_at
FROM vw_stg_title_ratings_clean r
JOIN dim_title t
  ON r.tconst = t.title_id;

CREATE OR REPLACE TABLE fact_episode_ratings AS
SELECT
  e.tconst AS episode_id,
  e.parentTconst AS series_id,
  e.seasonNumber,
  e.episodeNumber,
  r.average_rating,
  r.num_votes,
  CURRENT_TIMESTAMP() AS created_at
FROM stg_title_episode e
LEFT JOIN stg_title_ratings r
  ON e.tconst = r.tconst;
