/*=====================================================
  BRIDGE TABLE
=====================================================*/

CREATE OR REPLACE TABLE bridge_title_person AS
SELECT
  tconst AS title_id,
  nconst AS person_id,
  category,
  job,
  characters,
  CURRENT_TIMESTAMP() AS created_at
FROM stg_title_principals;
