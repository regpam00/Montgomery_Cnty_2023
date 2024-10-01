-- Created in Microsoft VS Code using MySQL extension
CREATE DATABASE maryland_gov_salary;

-- Create table
CREATE TABLE department_salary (
department VARCHAR(3),
department_name VARCHAR(60), 
division VARCHAR(90),
gender VARCHAR(1),
base_salary VARCHAR(10),
overtime_pay VARCHAR(10),
longevity_pay VARCHAR(10),
grade VARCHAR(3)
);

-- Check if the local_infile is disabled or enabled
SHOW GLOBAL variables LIKE 'local_infile';

SET GLOBAL local_infile = TRUE;
SHOW VARIABLES WHERE Variable_Name LIKE "%dir";

-- Load data from csv file using Windows
LOAD DATA LOCAL INFILE 'C:\\Users\\Regine Pamphile\\Desktop\\Practice SQL\\Employee_Salaries_-_2023.csv'
INTO TABLE department_salary
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM department_salary;
-- ALTER TABLE department_salary MODIFY COLUMN base_salary DECIMAL(10,2);
-- ALTER TABLE department_salary MODIFY COLUMN overtime_pay DECIMAL(10,2);
-- ALTER TABLE department_salary MODIFY COLUMN longevity_pay DECIMAL(10,2);

UPDATE department_salary SET grade = NULL WHERE grade = 'NUL';
--DROP TABLE department_salary;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Average salary per department
SELECT department, department_name, ROUND(AVG(base_salary)) AS "avg_salary" FROM department_salary GROUP BY department, department_name;

SELECT department, department_name, 
ROUND(SUM(CASE WHEN gender = "M" THEN base_salary ELSE 0 END)) AS "male_base_salary", 
ROUND(SUM(CASE WHEN gender = "F" THEN base_salary ELSE 0 END)) AS "female_base_salary"
FROM department_salary GROUP BY department, department_name;

-- Average salary per department per
SELECT department, department_name, 
ROUND(AVG(CASE WHEN gender = "M" THEN base_salary ELSE 0 END)) AS "male_base_salary", 
ROUND(AVG(CASE WHEN gender = "F" THEN base_salary ELSE 0 END)) AS "female_base_salary"
FROM department_salary GROUP BY department, department_name;

-- Max salary for males per department (highest to lowest)
SELECT department, department_name, ROUND(MAX(base_salary)) FROM department_salary WHERE gender = "M" GROUP BY department, department_name ORDER BY ROUND(MAX(base_salary)) DESC;

-- Max salary for females per department (highest to lowest)
SELECT department, department_name, ROUND(MAX(base_salary)) FROM department_salary WHERE gender = "F" GROUP BY department, department_name ORDER BY ROUND(MAX(base_salary)) DESC;

-- Overtime pay for each gender
SELECT gender, COUNT(overtime_pay) AS "overtime_counts" FROM department_salary WHERE overtime_pay <> 0 GROUP BY gender;
SELECT gender, ROUND(AVG(overtime_pay)) AS "avg_overtime_pay" FROM department_salary GROUP BY gender;

SELECT gender, department, department_name, MAX(overtime_pay) FROM department_salary WHERE gender = "F" GROUP BY department, department_name ORDER BY MAX(overtime_pay) DESC;
SELECT gender, department, department_name, MAX(overtime_pay) FROM department_salary WHERE gender = "M" GROUP BY department, department_name ORDER BY MAX(overtime_pay) DESC;

-- Longevity pay for each gender
SELECT gender, COUNT(longevity_pay) AS "longevity_counts" FROM department_salary WHERE longevity_pay <> 0 GROUP BY gender;
SELECT gender, ROUND(AVG(longevity_pay)) AS "avg_longevity_pay" FROM department_salary GROUP BY gender; 

SELECT gender, department, department_name, MAX(overtime_pay) FROM department_salary WHERE gender = "F" GROUP BY department, department_name ORDER BY MAX(overtime_pay) DESC;
SELECT gender, department, department_name, MAX(overtime_pay) FROM department_salary WHERE gender = "M" GROUP BY department, department_name ORDER BY MAX(overtime_pay) DESC;

-- Percentage of employees with income >= 100,000
SELECT gender, COUNT(base_salary) AS "100K_salary", ROUND((COUNT(base_salary)*100)/t.sum, 2) AS "100K_salary_%" FROM department_salary 
JOIN (SELECT COUNT(base_salary) AS "sum" FROM department_salary WHERE base_salary >= 100000)t WHERE base_salary >= 100000 GROUP BY gender, t.sum;

-- Percentage of employees with income >= 200,000
SELECT gender, COUNT(base_salary) AS "200K_salary", ROUND((COUNT(base_salary)*100)/t.sum, 2) AS "200K_salary_%" FROM department_salary 
JOIN (SELECT COUNT(base_salary) AS "sum" FROM department_salary WHERE base_salary >= 200000)t WHERE base_salary >= 200000 GROUP BY gender, t.sum;

-- Average salary per grade
SELECT grade, ROUND(AVG(base_salary)) AS "avg_salary" FROM department_salary GROUP BY grade ORDER BY grade;

