# 🎬 IMDb Analytics & Recommendation Platform

## 📌 Project Overview
The **IMDb Analytics & Recommendation Platform** is an end-to-end data engineering and analytics project built using **AWS and Python**. The goal of this project is to ingest large-scale IMDb public datasets, store them in a cloud-based data lake, and prepare them for analytics and recommendation use cases.

This repository currently focuses on the **data ingestion pipeline**, which uploads raw IMDb CSV datasets from a local environment to **AWS S3** using **boto3**, following industry-standard data lake design principles.

---

## 🏗️ Architecture

```
Local Machine (IMDb CSV files)
        ↓
Python + boto3
        ↓
AWS S3 (Raw Data Layer)
        ↓
Snowflake (next phase)
        ↓
Analytics & Recommendation Engine
```

---

## 📂 Dataset Description
The project uses the official IMDb public datasets:

| Dataset | Description |
|-------|------------|
| name.basics.csv | Actor, director, and crew details |
| title.basics.csv | Core movie/TV metadata |
| title.ratings.csv | IMDb ratings and vote counts |
| title.crew.csv | Directors and writers |
| title.principals.csv | Cast and crew roles |
| title.episode.csv | TV episode information |
| title.akas.csv | Regional and alternate titles |

---

## 🗂️ S3 Data Lake Structure

```
s3://imdb-analytics-data-2025/
 └── raw/
     ├── name.basics.csv
     ├── title.basics.csv
     ├── title.ratings.csv
     ├── title.crew.csv
     ├── title.principals.csv
     ├── title.episode.csv
     └── title.akas.csv
```

- **Raw Layer**: Stores unmodified source data
- Enables reproducibility and reprocessing

---

## ⚙️ Tech Stack

- **Language:** Python 3.11
- **Cloud:** AWS S3
- **SDK:** boto3
- **CLI:** AWS CLI v2
- **Version Control:** Git & GitHub

---

## 🚀 Pipeline: Upload IMDb Datasets to S3

### Key Features
- Programmatic S3 bucket creation
- Bulk CSV uploads from local folder
- Structured S3 folder (`raw/`)
- Error handling and logging
- IAM-based authentication (no hardcoded keys)

### Script

```bash
upload_imdb_datasets_to_s3.py
```

The script:
1. Checks if the S3 bucket exists
2. Creates the bucket if missing
3. Uploads all IMDb CSV files from a local directory
4. Stores them in the S3 `raw/` layer

---

## ▶️ How to Run

### 1. Configure AWS Credentials

```bash
aws configure
```

### 2. Install Dependencies

```bash
pip install boto3
```

### 3. Run the Script

```bash
python upload_imdb_datasets_to_s3.py
```

---

## ✅ Sample Output

```
Bucket 'imdb-analytics-data-2025' created successfully!
Uploaded: title.basics.csv
Uploaded: title.ratings.csv
...
All files uploaded successfully
```

---

## 🔐 Security Best Practices

- IAM user (not root)
- No credentials committed to GitHub
- `.gitignore` used to exclude sensitive files

---

## 📈 Future Enhancements

- Snowflake external stage from S3
- Staging, fact, and dimension tables
- Automated ingestion using Snowflake Tasks / Airflow
- Data quality checks
- Analytics dashboards (Power BI / Tableau)
- Content-based recommendation engine

---

## 🧠 Resume Description

> Built an end-to-end cloud data ingestion pipeline using Python and AWS S3 to process IMDb public datasets. Implemented automated uploads using boto3, designed a raw data lake structure, and followed cloud security and data engineering best practices. The pipeline serves as the foundation for analytics and recommendation workloads using Snowflake.

---

## 👤 Author
**Manichandra Domala**

---

⭐ If you find this project useful, feel free to star the repository!

