## 🛍️ Online Retail Analytics & Predictive Modeling

A complete end-to-end SQL + Python project focused on pricing and basket value prediction using the UCI Online Retail Dataset.

---

### 📌 **Project Overview**

This project analyzes e-commerce transactional data to identify purchasing patterns, engineer features for modeling, and predict invoice values. The entire pipeline includes:

- Data exploration & cleaning in **SQL**
- Feature engineering for modeling
- Exporting prepared data to **Python** for visualization & regression modeling
- Planning for a future **Power BI** dashboard

---

### 🧰 **Tech Stack**

| Tool/Language     | Usage                            |
|-------------------|----------------------------------|
| PostgreSQL + DBeaver | Data cleaning, exploration, feature engineering |
| Python (Pandas, Seaborn, Scikit-learn) | Data export, visualization, regression modeling |
| Power BI *(Upcoming)*  | Dashboarding and KPI visualization |
| GitHub            | Project versioning and sharing  |

---

### 🗂️ **Project Structure**

```
SQL_Pricing_Project/
│
├── sql/                         # SQL scripts for cleaning & feature engineering
│   ├── 01_data_cleaning.sql
│   ├── 02_feature_engineering.sql
│   └── 03_final_export.sql
│
├── python/
│   ├── data_visualization.ipynb
│   └── regression_modeling.ipynb
│
├── data/
│   └── online_retail_model_data.csv  # Cleaned data for modeling & BI
│
├── dashboard/ (planned)
│   └── online_retail_dashboard.pbix
│
└── README.md
```

---

### 🔍 **Step-by-Step Workflow**

#### 1. 🧹 SQL Data Cleaning

- Removed duplicate records
- Filtered negative quantity and price values
- Checked for missing/null values

#### 2. 🧠 Feature Engineering in SQL

- Created `TotalInvoiceAmount`, `TotalItems`, `DistinctProducts`
- Created binary label `HighValueBasket` based on invoice value threshold
- Aggregated features by invoice using `GROUP BY` and `CASE` statements

#### 3. 📦 Data Export to CSV

- Prepared the modeling-ready data using SQL `SELECT INTO`
- Exported to CSV via Python (`df.to_csv()`)

#### 4. 📊 Data Visualization (Python)

- Visualized skewed distribution of `TotalInvoiceAmount`
- Applied log transformation to normalize values
- Observed customer/product patterns over time

#### 5. 🤖 Regression Modeling

- Target: `TotalInvoiceAmount`
- Models tested:
  - Linear Regression *(R² = 0.26)*
  - Random Forest *(R² = 0.72)*
  - XGBoost *(R² = 0.74)*
  - Decision Tree *(R² = 0.75)*
- Final model selected: **XGBoost** for better performance

---

### 🧠 Key Learnings

- Full SQL workflow for real-world e-commerce analytics
- Advanced SQL functions (window functions, aggregations, CASE)
- Regression modeling pipeline in Python
- Preparing data for BI tools like Power BI

---

### 🔮 Next Steps

- ✅ Build a Power BI dashboard using exported CSV
