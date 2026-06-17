Create DATABASE Hospital_ER_DB;
Use Hospital_ER_DB;

CREATE TABLE Hospital_ER_Data
(   patient_id              VARCHAR(20),
    patient_admission_date  VARCHAR(50),
    patient_first_initial   VARCHAR(50),
    patient_last_name       VARCHAR(50),
    patient_gender          VARCHAR(20),
    patient_age             VARCHAR(35),
    patient_race            VARCHAR(50),
    department_referral     VARCHAR(100),
    patient_admission_flag  VARCHAR(25),
    
    patient_sat_score       VARCHAR(25),
    patient_waittime        VARCHAR(50),
    patients_cm             VARCHAR(50)
);

### Understand DataSet
SELECT COUNT(*) FROM Hospital_ER_Data;
select * from Hospital_ER_Data;

## Data Quality Check
# 1) Checks Null
SELECT
    SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END) AS Null_ID,
    SUM(CASE WHEN patient_admission_date IS NULL THEN 1 ELSE 0 END) AS Null_Date,
    SUM(CASE WHEN patient_gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
    SUM(CASE WHEN patient_age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
    SUM(CASE WHEN department_referral IS NULL THEN 1 ELSE 0 END) AS Null_Dept
FROM Hospital_ER_Data;

# 2) Duplicate check 
SELECT patient_id, COUNT(*) AS duplicate_count
FROM Hospital_ER_Data
GROUP BY patient_id
HAVING COUNT(*) > 1;

# 3) Invalid value check 
SELECT *
FROM Hospital_ER_Data
WHERE patient_age < 0 OR patient_age > 120;

# Clean Data
CREATE VIEW vw_ER_Clean AS
SELECT
    patient_id,
    patient_admission_date,
    patient_first_initial,
    patient_last_name,
    COALESCE(patient_gender, 'Unknown') AS patient_gender,
    COALESCE(patient_race, 'Unknown') AS patient_race,
    COALESCE(department_referral, 'Not Assigned') AS department_referral,
    patient_age,
    patient_waittime,
    patient_sat_score,
    patient_admission_flag,
    patients_cm
FROM Hospital_ER_Data;

# FEATURE ENGINEERING VIEW
# 1) Add Age Group logic
CREATE VIEW vw_ER_Features AS
SELECT *,
CASE
    WHEN patient_age BETWEEN 0 AND 9 THEN '0-9'
    WHEN patient_age BETWEEN 10 AND 19 THEN '10-19'
    WHEN patient_age BETWEEN 20 AND 29 THEN '20-29'
    WHEN patient_age BETWEEN 30 AND 39 THEN '30-39'
    WHEN patient_age BETWEEN 40 AND 49 THEN '40-49'
    WHEN patient_age BETWEEN 50 AND 59 THEN '50-59'
    ELSE '60+'
END AS age_group
FROM vw_ER_Clean;


# BASIC KPI QUERIES
# 1.Total Patients
SELECT COUNT(*) AS total_patients FROM vw_er_features;

# 2.Average Wait Time
SELECT AVG(patient_waittime) AS avg_wait_time FROM vw_er_features;

# 3.Average Satisfaction
SELECT AVG(patient_sat_score) AS avg_satisfaction FROM vw_er_features;

## BUSINESS ANALYSIS QUERIES
# 1) Gender Analysis
SELECT patient_gender, COUNT(*) AS total_patients FROM vw_er_features 
GROUP BY patient_gender;

# 2) Department Analysis
SELECT department_referral, COUNT(*) AS total_patients FROM vw_er_features
GROUP BY department_referral ORDER BY total_patients DESC;

# 3) Race Analysis
SELECT patient_race, COUNT(*) AS total_patients FROM vw_er_features
GROUP BY patient_race;

## DATE ANALYSIS
# 1) Daily Trend
SELECT
    DATE(STR_TO_DATE(patient_admission_date, '%d-%m-%Y %H:%i')) AS visit_date,
    COUNT(*) AS total_patients
FROM vw_er_features
GROUP BY DATE(STR_TO_DATE(patient_admission_date, '%d-%m-%Y %H:%i'))
ORDER BY visit_date;

# 2) Monthly Trend
   SELECT
    YEAR(STR_TO_DATE(patient_admission_date, '%d-%m-%Y %H:%i')) AS year,
    MONTH(STR_TO_DATE(patient_admission_date, '%d-%m-%Y %H:%i')) AS month,
    COUNT(*) AS total_patients
FROM vw_er_features
GROUP BY
    YEAR(STR_TO_DATE(patient_admission_date, '%d-%m-%Y %H:%i')),
    MONTH(STR_TO_DATE(patient_admission_date, '%d-%m-%Y %H:%i'));

## WINDOW FUNCTION
# Running Total
SELECT
    visit_date,
    daily_patients,
    SUM(daily_patients) OVER (
        ORDER BY visit_date
    ) AS running_total
FROM (
    SELECT
        DATE(STR_TO_DATE(patient_admission_date, '%d-%m-%Y %H:%i')) AS visit_date,
        COUNT(*) AS daily_patients
    FROM vw_er_features
    GROUP BY visit_date
) t
ORDER BY visit_date;

### FINAL POWER BI VIEW
CREATE VIEW vw_ER_Dashboard AS
SELECT
    patient_id,
    patient_admission_date,
    patient_first_initial,
    patient_last_name,
    patient_gender,
    patient_race,
    patient_age,
    age_group,
    department_referral,
    patient_waittime,
    patient_sat_score,
    patient_admission_flag,

    -- FIX DATE
    DATE(STR_TO_DATE(patient_admission_date, '%d-%m-%Y %H:%i')) AS visit_date,

    -- FIX HOUR
    HOUR(STR_TO_DATE(patient_admission_date, '%d-%m-%Y %H:%i')) AS visit_hour

FROM vw_er_features;

