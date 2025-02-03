# Insurance Claims Data Analysis

## Project Overview
This project focuses on analyzing an **Insurance Claims** dataset. The goal is to analyze claim frequencies, approval rates, and patterns based on factors like region, customer demographics, and vehicle features. The analysis is aimed at identifying insights to improve decision-making in the insurance industry, such as fraud detection and claim approval rates.

## Dataset
The dataset used in this project is the **Insurance Claims Dataset**, which contains detailed information about insurance policies, claims, vehicle features, and customer demographics.

- **Source:** [Kaggle - Insurance Claims Dataset](https://www.kaggle.com/datasets/litvinenko630/insurance-claims)
- **File:** `Insurance claims data.csv`
- **File Size:** Approximately 100,000 rows

## Tools & Technologies
- **Python:** Core programming language used for data analysis and visualization.
- **Libraries:**
  - **Pandas:** For data manipulation and analysis.
  - **Numpy:** For numerical operations.
  - **Matplotlib & Seaborn:** For data visualization (e.g., bar plots, histograms, correlation heatmaps).
  - **SQL (Optional):** If dealing with large datasets stored in databases.
  - **Tableau/Power BI (Optional):** For building dashboards and interactive reports.
- **Jupyter Notebook:** For running and documenting the analysis.
  
## Key Focus Areas
- **Claim Frequency Analysis:** Analyzing claim frequencies by region, demographics, and product type.
- **Claim Amount Analysis:** Understanding claim amounts, approval rates, and identifying key patterns.
- **Fraud Detection:** Using features like the ESC system, airbags, etc., to detect fraud in claims.
- **Data Cleaning & Preprocessing:** Handling missing data, duplicates, and converting columns to appropriate data types.

## Project Steps

### 1. Data Loading and Preprocessing
The first step is to load the dataset and perform data cleaning, including handling missing values, duplicates, and converting data types where necessary.

```python
import pandas as pd

# Load dataset
file_path = r'F:\Portfolio p\Insurance claims data\Insurance claims data.csv'
df = pd.read_csv(file_path)

# Check for missing values and duplicates
df.isnull().sum()  # Checking for missing values
df.duplicated().sum()  # Checking for duplicate rows

# Handle missing values and duplicates
df = df.dropna()  # Drop rows with missing values
df = df.drop_duplicates()  # Remove duplicate rows

### 2. Data Analysis & Insights
# Group by region and analyze claim frequency
region_claim_analysis = df.groupby('region_code').agg(
    total_claims=('claim_status', 'count'),
    claim_approval_rate=('claim_status', 'mean')
).reset_index()

# Visualize claim frequency by region
import seaborn as sns
import matplotlib.pyplot as plt

plt.figure(figsize=(10, 6))
sns.barplot(x='region_code', y='total_claims', data=region_claim_analysis, palette="coolwarm")
plt.title('Claim Frequency by Region')
plt.xlabel('Region')
plt.ylabel('Total Claims')
plt.show()

### 3. Correlation Heatmap
# Select numeric columns and calculate correlation matrix
numeric_df = df.select_dtypes(include=[np.number])

# Plot the heatmap
plt.figure(figsize=(10, 8))
sns.heatmap(numeric_df.corr(), annot=True, cmap='coolwarm', fmt='.2f')
plt.title('Correlation Heatmap of Numerical Features')
plt.show()

### 4. Fraud Detection Analysis

# Fraud detection based on ESC system
fraud_features_analysis = df.groupby('is_esc').agg(
    fraud_rate=('claim_status', lambda x: (x == 0).mean())
).reset_index()

# View the fraud analysis results
print(fraud_features_analysis)

