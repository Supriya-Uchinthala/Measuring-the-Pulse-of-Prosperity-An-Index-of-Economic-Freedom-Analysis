/* ============================================================
   PROJECT: Measuring the Pulse of Prosperity
   Analysis of the Index of Economic Freedom (2022)
   Tools Used: MySQL
   ============================================================ */


/* ============================================================
   1. DATABASE CREATION
   ============================================================ */

CREATE DATABASE IF NOT EXISTS economic_freedom;
USE economic_freedom;


/* ============================================================
   2. TABLE STRUCTURE
   ============================================================ */

CREATE TABLE IF NOT EXISTS freedom_index (
    Country_id INT,
    Country_Name VARCHAR(100),
    Region VARCHAR(100),
    World_Rank INT,
    Region_Rank INT,
    Score_2022 FLOAT,
    Property_Rights FLOAT,
    Judicial_Effectiveness FLOAT,
    Government_Integrity FLOAT,
    Tax_Burden FLOAT,
    Govt_Spending FLOAT,
    Fiscal_Health FLOAT,
    Business_Freedom FLOAT,
    Labor_Freedom FLOAT,
    Monetary_Freedom FLOAT,
    Trade_Freedom FLOAT,
    Investment_Freedom FLOAT,
    Financial_Freedom FLOAT,
    Tariff_Rate FLOAT,
    Income_Tax_Rate FLOAT,
    Corporate_Tax_Rate FLOAT,
    Tax_Burden_GDP FLOAT,
    Govt_Expenditure_GDP FLOAT,
    Population_Millions FLOAT,
    GDP_Billions FLOAT,
    GDP_Growth FLOAT,
    GDP_5yr_Growth FLOAT,
    GDP_per_Capita FLOAT,
    Unemployment FLOAT,
    Inflation FLOAT,
    FDI_Inflow FLOAT,
    Public_Debt FLOAT
);


/* ============================================================
   3. DATA VALIDATION
   ============================================================ */

-- Total number of countries
SELECT COUNT(*) AS Total_Countries
FROM freedom_index;

-- Check for duplicate countries
SELECT Country_Name, COUNT(*) AS Duplicate_Count
FROM freedom_index
GROUP BY Country_Name
HAVING COUNT(*) > 1;

-- Check NULL values in key economic indicators
SELECT 
SUM(CASE WHEN Score_2022 IS NULL THEN 1 ELSE 0 END) AS Null_Score,
SUM(CASE WHEN GDP_per_Capita IS NULL THEN 1 ELSE 0 END) AS Null_GDP,
SUM(CASE WHEN Unemployment IS NULL THEN 1 ELSE 0 END) AS Null_Unemployment,
SUM(CASE WHEN FDI_Inflow IS NULL THEN 1 ELSE 0 END) AS Null_FDI
FROM freedom_index;


/* ============================================================
   4. CREATE ECONOMIC FREEDOM CATEGORY
   ============================================================ */

ALTER TABLE freedom_index
ADD COLUMN Freedom_Category VARCHAR(30);

UPDATE freedom_index
SET Freedom_Category =
CASE
    WHEN Score_2022 >= 80 THEN 'Free'
    WHEN Score_2022 >= 70 THEN 'Mostly Free'
    WHEN Score_2022 >= 60 THEN 'Moderately Free'
    WHEN Score_2022 >= 50 THEN 'Mostly Unfree'
    ELSE 'Repressed'
END;

-- Distribution by category
SELECT Freedom_Category, COUNT(*) AS Country_Count
FROM freedom_index
GROUP BY Freedom_Category
ORDER BY Country_Count DESC;


/* ============================================================
   5. GLOBAL RANKING ANALYSIS
   ============================================================ */

-- Top 10 Economically Free Countries
SELECT Country_Name, Score_2022
FROM freedom_index
ORDER BY Score_2022 DESC
LIMIT 10;

-- Bottom 10 Countries
SELECT Country_Name, Score_2022
FROM freedom_index
ORDER BY Score_2022 ASC
LIMIT 10;


/* ============================================================
   6. REGIONAL ANALYSIS
   ============================================================ */

-- Average Economic Freedom Score by Region
SELECT Region,
ROUND(AVG(Score_2022),2) AS Avg_Freedom_Score
FROM freedom_index
GROUP BY Region
ORDER BY Avg_Freedom_Score DESC;

-- Average GDP per Capita by Region
SELECT Region,
ROUND(AVG(GDP_per_Capita),2) AS Avg_GDP_Per_Capita
FROM freedom_index
GROUP BY Region
ORDER BY Avg_GDP_Per_Capita DESC;


/* ============================================================
   7. FREEDOM VS ECONOMIC PERFORMANCE
   ============================================================ */

-- Freedom vs GDP per Capita
SELECT Country_Name, Score_2022, GDP_per_Capita
FROM freedom_index
ORDER BY Score_2022 DESC;

-- Trade Freedom vs FDI Inflow
SELECT Country_Name, Trade_Freedom, FDI_Inflow
FROM freedom_index
ORDER BY Trade_Freedom DESC;

-- Business Freedom vs Unemployment
SELECT Country_Name, Business_Freedom, Unemployment
FROM freedom_index
ORDER BY Business_Freedom DESC;

-- Fiscal Health vs Public Debt
SELECT Country_Name, Fiscal_Health, Public_Debt
FROM freedom_index
ORDER BY Fiscal_Health DESC;


/* ============================================================
   8. CATEGORY-BASED ECONOMIC COMPARISON
   ============================================================ */

-- Average GDP per Capita by Freedom Category
SELECT Freedom_Category,
ROUND(AVG(GDP_per_Capita),2) AS Avg_GDP
FROM freedom_index
GROUP BY Freedom_Category
ORDER BY Avg_GDP DESC;

-- Average Unemployment by Category
SELECT Freedom_Category,
ROUND(AVG(Unemployment),2) AS Avg_Unemployment
FROM freedom_index
GROUP BY Freedom_Category
ORDER BY Avg_Unemployment;

-- Average FDI Inflow by Category
SELECT Freedom_Category,
ROUND(AVG(FDI_Inflow),2) AS Avg_FDI
FROM freedom_index
GROUP BY Freedom_Category
ORDER BY Avg_FDI DESC;

-- Average Public Debt by Category
SELECT Freedom_Category,
ROUND(AVG(Public_Debt),2) AS Avg_Public_Debt
FROM freedom_index
GROUP BY Freedom_Category
ORDER BY Avg_Public_Debt DESC;


/* ============================================================
   9. SUMMARY STATISTICS
   ============================================================ */

-- Overall Averages
SELECT 
ROUND(AVG(Score_2022),2) AS Avg_Freedom,
ROUND(AVG(GDP_per_Capita),2) AS Avg_GDP,
ROUND(AVG(Unemployment),2) AS Avg_Unemployment,
ROUND(AVG(FDI_Inflow),2) AS Avg_FDI,
ROUND(AVG(Public_Debt),2) AS Avg_Public_Debt
FROM freedom_index;
