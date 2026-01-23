# 🎬 IMDb Analytics & Recommendation Platform

An **end-to-end, production-ready data engineering pipeline** that ingests IMDb datasets from a local environment, stages them in **AWS S3**, loads them into **Snowflake**, and transforms them into **analytics-ready fact and dimension tables** for BI and recommendation use cases.

The entire pipeline is **fully automated** and can be executed with **a single command**.

---

## 🚀 Key Highlights

- End-to-end automation (Local → S3 → Snowflake)
- Secure **Snowflake key-pair authentication** (no passwords)
- AWS IAM role-based access for Snowflake
- Modular SQL transformations
- Incremental loading using `MERGE`
- Built-in data quality checks
- Clean Git repository (no raw data, no secrets)

---

## 🏗️ Architecture

```
Local IMDb CSVs
      ↓
Python (boto3)
      ↓
AWS S3 (Raw Layer)
      ↓
Snowflake External Stage
      ↓
Staging Tables
      ↓
Clean Staging Views
      ↓
Dimension Tables
      ↓
Fact & Bridge Tables
      ↓
Analytics / BI / Recommendations
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-----|-----------|
| Language | Python 3 |
| Cloud Storage | AWS S3 |
| Data Warehouse | Snowflake |
| Authentication | Snowflake RSA Key-Pair |
| Transformations | SQL |
| Orchestration | Python |
| Version Control | Git / GitHub |
| BI (Optional) | Tableau Public |

---

## 📂 Project Structure

```
imdb_project/
│
├── src/
│   └── upload_imdb_datasets_to_s3.py
│
├── sql/
│   ├── staging_tables.sql
│   ├── staging_views.sql
│   ├── dimensions.sql
│   ├── facts.sql
│   ├── bridge_tables.sql
│   ├── data_quality.sql
│   └── incremental_merge.sql
│
├── run_pipeline.py
├── .gitignore
└── README.md
```

---

## 📥 Data Source

IMDb public datasets (CSV format), including:

- title.basics
- title.ratings
- name.basics
- title.crew
- title.principals
- title.episode
- title.akas

> ⚠️ Raw CSV files are **not committed** to GitHub.

---

## 🔐 Security & Authentication

This project uses **Snowflake key-pair authentication** instead of passwords.

### Why an environment variable is required
The Snowflake private key is **encrypted with a passphrase**.  
At runtime, the passphrase is injected securely via an environment variable so that **no secrets are stored in source code or version control**.

### Required environment variable
```bash
export SNOWFLAKE_PRIVATE_KEY_PASSPHRASE="your_private_key_password"
```

---

## ⚙️ Prerequisites

- Python 3.9+
- AWS credentials configured (`aws configure`)
- Snowflake account with:
  - ACCOUNTADMIN role
  - Warehouse access
  - Storage integration configured
- AWS S3 bucket created

---

## ▶️ How to Run the Pipeline

### 1️⃣ Install dependencies
```bash
pip install boto3 snowflake-connector-python cryptography
```

### 2️⃣ Set environment variable
```bash
export SNOWFLAKE_PRIVATE_KEY_PASSPHRASE="your_private_key_password"
```

### 3️⃣ Run the pipeline
```bash
python run_pipeline.py
```

### ✅ Expected Output
```
🚀 Pipeline started
🚀 Uploading local IMDb datasets to S3...
✅ S3 upload completed
❄️ Connecting to Snowflake...
Running sql/staging_tables.sql
Running sql/staging_views.sql
Running sql/dimensions.sql
Running sql/facts.sql
Running sql/bridge_tables.sql
Running sql/data_quality.sql
Running sql/incremental_merge.sql
🎉 FULL PIPELINE COMPLETED SUCCESSFULLY
```

---

## 🧱 Data Model

### Dimension Tables
- dim_title – Movies & TV shows
- dim_person – Actors, directors, crew

### Fact Tables
- fact_title_ratings
- fact_episode_ratings

### Bridge Tables
- bridge_title_person (many-to-many relationships)

---

## 🧪 Data Quality Checks

The pipeline validates:
- Null primary keys
- Rating values outside valid range (0–10)
- Orphaned fact records

---

## 📈 Analytics Use Cases

- Top-rated movies by year
- Genre-based popularity analysis
- Actor collaboration networks
- Episode rating trends by season
- Recommendation-ready star schema

Optimized for **Tableau Public** and other BI tools.

---

## 🔄 Incremental Load Strategy

- Full refresh into staging tables
- Incremental MERGE into fact tables
- Production-ready loading pattern

---

## 📊 Tableau Dashboard
Dashboard Insights

- Top-rated titles and popularity
- Ratings vs popularity (votes)
- Rating trends over time

## 👤 Author

**Manichandra Domala**  
IMDb Analytics & Recommendation Platform
