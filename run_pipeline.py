"""
run_pipeline.py

End-to-end IMDb data pipeline orchestrator:
Local CSVs → AWS S3 → Snowflake → Analytics tables

Authentication:
- Snowflake key-pair authentication (no passwords)

Execution:
- Single command runs the full pipeline
"""

import os
import boto3
import snowflake.connector
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.backends import default_backend

# =====================================================
# PROJECT PATHS (PORTABLE)
# =====================================================

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(PROJECT_DIR, "imdb_datasets")
SQL_DIR = os.path.join(PROJECT_DIR, "sql")

# =====================================================
# AWS S3 CONFIG
# =====================================================

S3_BUCKET = "imdb-analytics-data-2025"
S3_PREFIX = "raw/"

# =====================================================
# SQL EXECUTION ORDER
# =====================================================

SQL_FILES = [
    "staging_tables.sql",
    "staging_views.sql",
    "dimensions.sql",
    "facts.sql",
    "bridge_tables.sql",
    "data_quality.sql",
    "incremental_merge.sql",
]

# =====================================================
# LOAD SNOWFLAKE PRIVATE KEY (SECURE)
# =====================================================

PRIVATE_KEY_PATH = os.path.expanduser("~/.snowflake/rsa_key.p8")
PRIVATE_KEY_PASSPHRASE = os.getenv("SNOWFLAKE_PRIVATE_KEY_PASSPHRASE")

if not PRIVATE_KEY_PASSPHRASE:
    raise RuntimeError(
        "SNOWFLAKE_PRIVATE_KEY_PASSPHRASE environment variable is not set"
    )

with open(PRIVATE_KEY_PATH, "rb") as key_file:
    private_key = serialization.load_pem_private_key(
        key_file.read(),
        password=PRIVATE_KEY_PASSPHRASE.encode(),
        backend=default_backend()
    )

# Convert private key to DER format (required by Snowflake)
PRIVATE_KEY_DER = private_key.private_bytes(
    encoding=serialization.Encoding.DER,
    format=serialization.PrivateFormat.PKCS8,
    encryption_algorithm=serialization.NoEncryption()
)

# =====================================================
# SNOWFLAKE CONNECTION CONFIG
# =====================================================

SNOWFLAKE_CONFIG = {
    "user": "manidomala",
    "account": "mkc10080.us-east-1",
    "private_key": PRIVATE_KEY_DER,
    "warehouse": "IMDB_WH",
    "database": "IMDB_DB",
    "schema": "PUBLIC",
    "role": "ACCOUNTADMIN",
}


# =====================================================
# FUNCTIONS
# =====================================================

def upload_to_s3():
    """Upload local IMDb CSV files to AWS S3 raw layer."""
    print("\n🚀 Uploading local IMDb datasets to S3...")
    s3 = boto3.client("s3")

    for file_name in os.listdir(DATA_DIR):
        if file_name.endswith(".csv"):
            local_path = os.path.join(DATA_DIR, file_name)
            s3_key = f"{S3_PREFIX}{file_name}"
            s3.upload_file(local_path, S3_BUCKET, s3_key)
            print(f"Uploaded → s3://{S3_BUCKET}/{s3_key}")

    print("✅ S3 upload completed")


def execute_sql_file(cursor, file_path):
    """Execute SQL statements from a file."""
    with open(file_path, "r") as f:
        statements = f.read().split(";")
        for stmt in statements:
            stmt = stmt.strip()
            if stmt:
                cursor.execute(stmt)


def run_snowflake_pipeline():
    """Run Snowflake SQL transformations in sequence."""
    print("\n❄️ Connecting to Snowflake...")
    conn = snowflake.connector.connect(**SNOWFLAKE_CONFIG)
    cursor = conn.cursor()

    try:
        for sql_file in SQL_FILES:
            file_path = os.path.join(SQL_DIR, sql_file)
            print(f"Running sql/{sql_file}")
            execute_sql_file(cursor, file_path)

        print("\n🎉 FULL PIPELINE COMPLETED SUCCESSFULLY")

    finally:
        cursor.close()
        conn.close()

# =====================================================
# MAIN
# =====================================================

def main():
    print("🚀 Pipeline started")
    upload_to_s3()
    run_snowflake_pipeline()


if __name__ == "__main__":
    main()
