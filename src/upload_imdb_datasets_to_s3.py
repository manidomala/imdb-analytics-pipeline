import boto3
import os
from botocore.exceptions import ClientError

# AWS S3 setup
s3 = boto3.client("s3")
bucket_name = "imdb-analytics-data-2025"  # your bucket
local_folder = "/Users/manichandradomala/Desktop/imdb_datasets"
s3_folder = "raw/"

# Step 1: Create bucket if it doesn't exist
try:
    existing_buckets = [b['Name'] for b in s3.list_buckets()['Buckets']]
    if bucket_name not in existing_buckets:
        # Special case for us-east-1
        region = "us-east-1"
        if region == "us-east-1":
            s3.create_bucket(Bucket=bucket_name)
        else:
            s3.create_bucket(
                Bucket=bucket_name,
                CreateBucketConfiguration={'LocationConstraint': region}
            )
        print(f"Bucket '{bucket_name}' created successfully!")
    else:
        print(f"Bucket '{bucket_name}' already exists.")
except ClientError as e:
    print("Bucket creation error:", e)

# Step 2: Upload files
for file_name in os.listdir(local_folder):
    if file_name.endswith(".csv"):
        local_path = os.path.join(local_folder, file_name)
        s3_key = f"{s3_folder}{file_name}"  # e.g., raw/title.basics.csv
        try:
            s3.upload_file(Filename=local_path, Bucket=bucket_name, Key=s3_key)
            print(f"Uploaded: {file_name} -> s3://{bucket_name}/{s3_key}")
        except ClientError as e:
            print(f"Error uploading {file_name}: {e}")

print("✅ All files uploaded successfully")
