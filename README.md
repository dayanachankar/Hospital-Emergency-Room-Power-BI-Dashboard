# Hospital-Emergency-Room-Power-BI-Dashboard
<img width="500" height="300" alt="ChatGPT Image Jun 17, 2026, 01_01_28 PM" src="https://github.com/user-attachments/assets/c49fec9b-ee1b-4791-935d-edb1eba69375" />

## 🛠️ Tools & Technologies

| Stage | Tool |
|---|---|
| 📦 Data Source | Kaggle |
| 🗄️ Data Storage & Cleaning | MySQL Workbench |
| 🔧 Feature Engineering | MySQL (SQL Queries) |
| 📊 Visualization | Microsoft Power BI |
| 🧮 Calculations | DAX (Data Analysis Expressions) |
| 🤖 AI Assistance | ChatGPT, Claude AI |

## 🔄 Project Workflow

```
Kaggle Dataset (CSV)
        ↓
  MySQL Database
  ├── Data Cleaning
  ├── Feature Engineering
  ├── Business Analysis Queries
  └── Final View Creation
        ↓
  Power BI Desktop
  ├── Data Connection (MySQL View)
  ├── DAX Measures
  └── Dashboard (3 Pages)
        ↓
  Insights & Reporting
```
## 📊 Dashboard Pages

### 1️⃣ Monthly View
Objective: Monitor key metrics and trends on a month-by-month basis to identify patterns and areas for improvement.

### 2️⃣ Consolidated View
Objective: Provide a holistic summary of hospital performance for a selected date range.

### 3️⃣ Patient Detail
Objective: Offer granular insights into patient-level data to enable detailed analysis and troubleshooting.

---
## 🧮 DAX Measures Created
```DAX
1.Total Patients = COUNTROWS(vw_ER_Dashboard)

2.Avg Wait Time = AVERAGE(vw_ER_Dashboard[patient_waittime])

3.Avg Satisfaction Score = AVERAGE(vw_ER_Dashboard[patient_sat_score])

4.Total Referred = CALCULATE(COUNTROWS(vw_ER_Dashboard),vw_ER_Dashboard[department_referral] <> "None")

5.Admitted Patients = CALCULATE(COUNTROWS(vw_ER_Dashboard),vw_ER_Dashboard[patient_admission_flag] = "Yes")

6.Not Admitted Patients = CALCULATE(COUNTROWS(vw_ER_Dashboard),vw_ER_Dashboard[patient_admission_flag] = "No")

7.% Within 30 Min = DIVIDE(CALCULATE(COUNTROWS(vw_ER_Dashboard),vw_ER_Dashboard[patient_waittime] <= 30),[Total Patients],0) * 100

8.% Over 30 Min = 100 - [% Within 30 Min]
```
## 📊 Project Insights

1. Analyzed **6,770 ER patient records** to uncover key bottlenecks in hospital flow and operational performance.
2. Identified **weekends (Sat–Sun, 07–08 hrs)** as peak hours, enabling data-driven staffing and resource allocation decisions.
3. Measured the percentage of patients treated **within and beyond the 30-minute target** wait time to assess service efficiency.
4. Analyzed **department referrals** to identify the most frequently referred departments and optimize patient routing.
5. Examined **patient demographics** across age, gender, and race to detect care disparity patterns and support equitable resource distribution.

*This project was built as part of my data analytics learning journey.*
