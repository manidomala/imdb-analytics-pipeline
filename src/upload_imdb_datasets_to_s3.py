"""
Upload IMDb datasets from local filesystem to AWS S3.

This script:
- Scans a local directory for IMDb CSV files
- Uploads them to an S3 bucket under a raw/ prefix
- Overwrites existing files (full refresh pattern)

Used as part of an end-to-end data pipeline.
"""

import os
import boto3

# ========================
# CONFIGURATION
# ========================

LOCAL_DATA_DIR = "/Users/manichandradomala/Desktop/imdb_project/imdb_datasets"
S3_BUCKET = "imdb-analytics-data-2025"
S3_PREFIX = "raw/"

# ========================
# S3 UPLOAD LOGIC
# ========================

def upload_files_to_s3():
    s3 = boto3.client("s3")

    print("🚀 Uploading local IMDb datasets to S3...")

    for filename in os.listdir(LOCAL_DATA_DIR):
        if filename.endswith(".csv"):
            local_path = os.path.join(LOCAL_DATA_DIR, filename)
            s3_key = f"{S3_PREFIX}{filename}"

            s3.upload_file(local_path, S3_BUCKET, s3_key)
            print(f"Uploaded → s3://{S3_BUCKET}/{s3_key}")

    print("✅ S3 upload completed")


if __name__ == "__main__":
    upload_files_to_s3()
