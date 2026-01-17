/*=====================================================
 INCREMENTAL LOAD (PRODUCTION PATTERN)
=====================================================*/

MERGE INTO fact_title_ratings tgt
USING vw_stg_title_ratings_clean src
ON tgt.title_id = src.tconst

WHEN MATCHED THEN UPDATE SET
    tgt.average_rating = src.average_rating,
    tgt.num_votes = src.num_votes,
    tgt.created_at = CURRENT_TIMESTAMP()

WHEN NOT MATCHED THEN INSERT (
    title_id,
    average_rating,
    num_votes,
    created_at
)
VALUES (
    src.tconst,
    src.average_rating,
    src.num_votes,
    CURRENT_TIMESTAMP()
);
