/*=====================================================
  CREATE CLEAN STAGING VIEWS
=====================================================*/

--Clean Title Basics
CREATE OR REPLACE VIEW vw_stg_title_basics_clean AS
SELECT
    tconst,
    title_type,
    primary_title,
    original_title,
    is_adult,
    TRY_TO_NUMBER(start_year) AS start_year,
    TRY_TO_NUMBER(end_year) AS end_year,
    TRY_TO_NUMBER(runtime_minutes) AS runtime_minutes,
    genres
FROM stg_title_basics
WHERE tconst IS NOT NULL;

--Clean Ratings
CREATE OR REPLACE VIEW vw_stg_title_ratings_clean AS
SELECT
    tconst,
    average_rating,
    num_votes
FROM stg_title_ratings
WHERE tconst IS NOT NULL;

--Clean People Data
CREATE OR REPLACE VIEW vw_stg_name_basics_clean AS
SELECT
    nconst,
    primary_name,
    TRY_TO_NUMBER(birth_year) AS birth_year,
    TRY_TO_NUMBER(death_year) AS death_year,
    primary_profession,
    known_for_titles
FROM stg_name_basics
WHERE nconst IS NOT NULL;

