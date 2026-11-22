
-- =====================================================
-- PROJECT: HR ANALYTICS & EMPLOYEE ATTRITION ANALYSIS
-- DATABASE: hr_analytics
-- TOOL: MySQL
-- =====================================================


-- =====================================================
-- SECTION 01: DATABASE SETUP
-- =====================================================
SHOW DATABASES;
-- Create Database
CREATE DATABASE IF NOT EXISTS hr_analytics;

-- Select Database
USE hr_analytics;

-- Import Note:
-- Table `hr-employee-attrition` was created by importing
-- HR-Employee-Attrition.csv (IBM HR Analytics dataset) using
-- MySQL Workbench > Table Data Import Wizard.

-- =====================================================
-- SECTION 02: DATA CLEANING & VALIDATION
-- =====================================================

-- Rename Age Column (Remove BOM Encoding Issue)
ALTER TABLE `hr-employee-attrition`
RENAME COLUMN `ï»¿Age` TO Age;

-- Check Table Columns
SHOW COLUMNS FROM `hr-employee-attrition`;

-- Check Total Number of Records
SELECT COUNT(*) AS total_employees
FROM `hr-employee-attrition`;


-- =====================================================
-- TASK 01: ATTRITION DISTRIBUTION
-- Business Question: How many employees left vs stayed?
-- =====================================================

SELECT
    Attrition,
    COUNT(*) AS employee_count
FROM `hr-employee-attrition`
GROUP BY Attrition;


-- =====================================================
-- TASK 02: DUPLICATE EMPLOYEE NUMBER CHECK
-- Business Question: Are Employee Numbers unique?
-- =====================================================

SELECT
    COUNT(*) AS employee_count,
    COUNT(DISTINCT EmployeeNumber) AS dist_employees
FROM `hr-employee-attrition`;


-- =====================================================
-- TASK 03: OVERALL ATTRITION RATE
-- Business Question: What is the overall attrition rate?
-- =====================================================

SELECT
    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS percentage_attrition
FROM `hr-employee-attrition`;


-- =====================================================
-- TASK 04: DEPARTMENT-WISE ATTRITION
-- Business Question: Which department has the highest attrition?
-- =====================================================

SELECT
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_employees,
    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate
FROM `hr-employee-attrition`
GROUP BY Department
ORDER BY attrition_rate DESC;


-- =====================================================
-- TASK 05: JOB ROLE-WISE ATTRITION
-- Business Question: Which job role has the highest attrition?
-- =====================================================

SELECT
    JobRole,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate
FROM `hr-employee-attrition`
GROUP BY JobRole
ORDER BY attrition_rate DESC;


-- =====================================================
-- TASK 06: AGE GROUP-WISE ATTRITION
-- Business Question: Which age group has the highest attrition?
-- =====================================================
-- Age Groups: Young (<=25), Early Career (26-35), Mid Career (36-45),
-- Experienced (46-55), Senior (56+)
SELECT
    CASE
        WHEN Age <= 25 THEN 'Young'
        WHEN Age <= 35 THEN 'Early Career'
        WHEN Age <= 45 THEN 'Mid Career'
        WHEN Age <= 55 THEN 'Experienced'
        ELSE 'Senior'
    END AS Age_Groups,
	COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate

FROM `hr-employee-attrition`
GROUP BY
    CASE
        WHEN Age <= 25 THEN 'Young'
        WHEN Age <= 35 THEN 'Early Career'
        WHEN Age <= 45 THEN 'Mid Career'
        WHEN Age <= 55 THEN 'Experienced'
        ELSE 'Senior'
    END
ORDER BY attrition_rate DESC;


-- =====================================================
-- TASK 07: OVERTIME VS ATTRITION
-- Business Question: Does overtime have an association with attrition?
-- =====================================================

SELECT
    OverTime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_employees,
    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate
FROM `hr-employee-attrition`
GROUP BY OverTime
ORDER BY attrition_rate DESC;


-- =====================================================
-- TASK 08: MONTHLY INCOME VS ATTRITION
-- Business Question: Which income group has the highest attrition?
-- =====================================================

SELECT
    CASE
        WHEN MonthlyIncome <= 5000 THEN '0-5000'
        WHEN MonthlyIncome <= 10000 THEN '5001-10000'
        WHEN MonthlyIncome <= 15000 THEN '10001-15000'
        ELSE '15000+'
    END AS Monthly_income_range,

    COUNT(*) AS total_employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_employees,

    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate

FROM `hr-employee-attrition`
GROUP BY
    CASE
        WHEN MonthlyIncome <= 5000 THEN '0-5000'
        WHEN MonthlyIncome <= 10000 THEN '5001-10000'
        WHEN MonthlyIncome <= 15000 THEN '10001-15000'
        ELSE '15000+'
    END
ORDER BY attrition_rate DESC;


-- =====================================================
-- TASK 09: JOB SATISFACTION VS ATTRITION
-- Business Question: How does job satisfaction relate to attrition?
-- =====================================================

SELECT
    CASE
        WHEN JobSatisfaction = 1 THEN 'low'
        WHEN JobSatisfaction = 2 THEN 'Medium'
        WHEN JobSatisfaction = 3 THEN 'High'
        ELSE 'Very High'
    END AS Job_Satisfaction,

    COUNT(*) AS total_employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_employees,

    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate

FROM `hr-employee-attrition`
GROUP BY
    CASE
        WHEN JobSatisfaction = 1 THEN 'low'
        WHEN JobSatisfaction = 2 THEN 'Medium'
        WHEN JobSatisfaction = 3 THEN 'High'
        ELSE 'Very High'
    END
ORDER BY attrition_rate DESC;


-- =====================================================
-- TASK 10: BUSINESS TRAVEL VS ATTRITION
-- Business Question: Does frequent business travel relate to attrition?
-- =====================================================

SELECT
    BusinessTravel,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_employees,
    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate
FROM `hr-employee-attrition`
GROUP BY BusinessTravel
ORDER BY attrition_rate DESC;


-- =====================================================
-- TASK 11: YEARS AT COMPANY VS ATTRITION
-- Business Question: Which tenure group has the highest attrition?
-- =====================================================

SELECT
    CASE
        WHEN YearsAtCompany <= 5 THEN '0-5'
        WHEN YearsAtCompany <= 10 THEN '6-10'
        WHEN YearsAtCompany <= 20 THEN '11-20'
        ELSE '20+'
    END AS Years_at_Company,

    COUNT(*) AS total_employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_employees,

    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate

FROM `hr-employee-attrition`
GROUP BY
    CASE
        WHEN YearsAtCompany <= 5 THEN '0-5'
        WHEN YearsAtCompany <= 10 THEN '6-10'
        WHEN YearsAtCompany <= 20 THEN '11-20'
        ELSE '20+'
    END
ORDER BY attrition_rate DESC;


-- =====================================================
-- TASK 12: WORK-LIFE BALANCE VS ATTRITION
-- Business Question: How does work-life balance relate to attrition?
-- =====================================================

SELECT
    CASE
        WHEN WorkLifeBalance = 1 THEN 'BAD'
        WHEN WorkLifeBalance = 2 THEN 'GOOD'
        WHEN WorkLifeBalance = 3 THEN 'BETTER'
        ELSE 'BEST'
    END AS Work_life_balance,

    COUNT(*) AS total_employees,

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_employees,

    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate

FROM `hr-employee-attrition`
GROUP BY
    CASE
        WHEN WorkLifeBalance = 1 THEN 'BAD'
        WHEN WorkLifeBalance = 2 THEN 'GOOD'
        WHEN WorkLifeBalance = 3 THEN 'BETTER'
        ELSE 'BEST'
    END
ORDER BY attrition_rate DESC;


-- =====================================================
-- TASK 13: GENDER-WISE ATTRITION
-- Business Question: How does attrition differ by gender?
-- =====================================================

SELECT
    Gender,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_employees,
    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate
FROM `hr-employee-attrition`
GROUP BY Gender
ORDER BY attrition_rate DESC;


-- =====================================================
-- TASK 14: EDUCATION FIELD VS ATTRITION
-- Business Question: Which education field has the highest attrition?
-- =====================================================

SELECT
    EducationField,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_employees,
    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*)) * 100, 2
    ) AS attrition_rate
FROM `hr-employee-attrition`
GROUP BY EducationField
ORDER BY attrition_rate DESC;


-- =====================================================
-- END OF HR ANALYTICS SQL ANALYSIS
-- =====================================================
