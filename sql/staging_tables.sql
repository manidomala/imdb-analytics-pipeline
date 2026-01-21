/*=====================================================
  STAGING TABLE SETUP
  - Creates warehouse, database, stage
  - Loads raw IMDb CSVs from S3 into staging tables
=====================================================*/

CREATE OR REPLACE WAREHOUSE imdb_wh
  WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE;

CREATE OR REPLACE DATABASE imdb_db;
USE DATABASE imdb_db;
USE WAREHOUSE imdb_wh;

/* File format for IMDb TSV/CSV files */
CREATE OR REPLACE FILE FORMAT imdb_csv_format
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('\\N','NULL','null');

/* External stage pointing to S3 raw data */
CREATE OR REPLACE STAGE imdb_stage
  URL = 's3://imdb-analytics-data-2025/raw/'
  STORAGE_INTEGRATION = imdb_s3_integration
  FILE_FORMAT = imdb_csv_format;

/* ========================
   STAGING TABLES
======================== */

CREATE OR REPLACE TABLE stg_title_basics (
  tconst STRING,
  title_type STRING,
  primary_title STRING,
  original_title STRING,
  is_adult INT,
  start_year INT,
  end_year INT,
  runtime_minutes INT,
  genres STRING
);

CREATE OR REPLACE TABLE stg_title_ratings (
  tconst STRING,
  average_rating FLOAT,
  num_votes INT
);

CREATE OR REPLACE TABLE stg_name_basics (
  nconst STRING,
  primary_name STRING,
  birth_year INT,
  death_year INT,
  primary_profession STRING,
  known_for_titles STRING
);

CREATE OR REPLACE TABLE stg_title_crew (
  tconst STRING,
  directors STRING,
  writers STRING
);

CREATE OR REPLACE TABLE stg_title_principals (
  tconst STRING,
  ordering INT,
  nconst STRING,
  category STRING,
  job STRING,
  characters STRING
);

CREATE OR REPLACE TABLE stg_title_episode (
  tconst STRING,
  parentTconst STRING,
  seasonNumber INT,
  episodeNumber INT
);

CREATE OR REPLACE TABLE stg_title_akas (
  titleId STRING,
  ordering INT,
  title STRING,
  region STRING,
  language STRING,
  types STRING,
  attributes STRING,
  isOriginalTitle INT
);

/* ========================
   FULL REFRESH LOAD
======================== */

TRUNCATE TABLE stg_title_basics;
TRUNCATE TABLE stg_title_ratings;
TRUNCATE TABLE stg_name_basics;
TRUNCATE TABLE stg_title_crew;
TRUNCATE TABLE stg_title_principals;
TRUNCATE TABLE stg_title_episode;
TRUNCATE TABLE stg_title_akas;

COPY INTO stg_title_basics     FROM @imdb_stage/title.basics.csv     ON_ERROR='CONTINUE';
COPY INTO stg_title_ratings    FROM @imdb_stage/title.ratings.csv    ON_ERROR='CONTINUE';
COPY INTO stg_name_basics      FROM @imdb_stage/name.basics.csv      ON_ERROR='CONTINUE';
COPY INTO stg_title_crew       FROM @imdb_stage/title.crew.csv       ON_ERROR='CONTINUE';
COPY INTO stg_title_principals FROM @imdb_stage/title.principals.csv ON_ERROR='CONTINUE';
COPY INTO stg_title_episode    FROM @imdb_stage/title.episode.csv    ON_ERROR='CONTINUE';
COPY INTO stg_title_akas       FROM @imdb_stage/title.akas.csv       ON_ERROR='CONTINUE';
