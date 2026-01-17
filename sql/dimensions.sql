/*=====================================================
  CREATE DIMENSIONS TABLE
=====================================================*/

--dim_title(Movies / Shows)
CREATE OR REPLACE TABLE dim_title AS
SELECT
    tconst              AS title_id,
    title_type,
    primary_title,
    original_title,
    start_year,
    end_year,
    runtime_minutes,
    genres,
    CURRENT_TIMESTAMP() AS created_at
FROM vw_stg_title_basics_clean
WHERE is_adult = 0;

--dim_person (Actors / Directors)
CREATE OR REPLACE TABLE dim_person AS
SELECT
    nconst              AS person_id,
    primary_name,
    birth_year,
    death_year,
    primary_profession,
    CURRENT_TIMESTAMP() AS created_at
FROM vw_stg_name_basics_clean;
