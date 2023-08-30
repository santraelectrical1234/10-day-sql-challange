/*
You have two tables in your database: employees and projects. The employees table contains information about employees, such as their employee_id,
 employee_name, team and salary. The projects table contains information about projects, including project_name, employee_id, start_date, expected_end_date, end_date, 
 and budget.

Your task is to write an SQL query to identify the most efficient employee within each team, considering their salary, the number of completed projects, 
the total worth of those projects, and the timely completion of projects and project completion bonuses or deductions:

To determine the efficiency of each employee within their respective team, we have formulated an advanced efficiency score that evaluates their value contribution to the
company, considering various factors. The efficiency score is designed to identify employees who deliver optimal value in relation to their salary, while also considering 
individual project completion performance.

The efficiency score is calculated using the following formula:

Efficiency Score = (Total Worth of Completed Projects * (1 + (Timely Completion Score * 0.2 + Bonus - Deduction))) / Salary

Where:

Total Worth of Completed Projects: This represents the sum of the budgets of all projects completed by the employee.
Timely Completion Score: For each project, this is a binary score (0 or 1) indicating whether the project was completed on or before the expected end date.
Bonus: A value to be added to the efficiency score for projects completed within time. The bonus rewards employees for completing projects earlier than the expected end date
in this scenario the value is 1.
Deduction: A value to be subtracted from the efficiency score for projects completed over time. The deduction penalizes employees for completing projects after the expected 
end date in this scenario the value is 0.5.
Salary: This refers to the employee's salary.

Your SQL query should display the team, employee_name and efficiency_score, below is an sample of query result.*/

create database empl_projects;

use empl_projects;
show tables;

select *  from employee;
select *  from projects;

USE employees_and_projects;

SELECT * FROM employee;

SELECT * FROM projects;

ALTER TABLE projects
ADD COLUMN new_start_date DATE, 
ADD COLUMN new_expected_end_date DATE,
ADD COLUMN new_end_date DATE;

SET SQL_SAFE_UPDATES = 0 ;

UPDATE projects
SET new_start_date = STR_TO_DATE(start_date,"%c/%e/%Y"),
    new_expected_end_date = STR_TO_DATE(expected_end_date,"%c/%e/%Y"),
    new_end_date = STR_TO_DATE(end_date,"%c/%e/%Y");
    
ALTER TABLE projects
DROP COLUMN start_date,
DROP COLUMN expected_end_date,
DROP COLUMN end_date;

ALTER TABLE projects
RENAME COLUMN new_start_date TO start_date,
RENAME COLUMN new_expected_end_date TO expected_end_date,
RENAME COLUMN new_end_date TO end_date;

SELECT * FROM employee;

SELECT * FROM projects;

# Challenge 7

SELECT * FROM employee;

SELECT * FROM projects;

-- Timely Completion Checking Query
SELECT project_name, employee_id, expected_end_date, end_date,
  (CASE WHEN end_date IS NOT NULL AND end_date <= expected_end_date THEN 1 ELSE 0 END) AS timely_completion_score
FROM projects;  

-- Query for CTE
SELECT 
  e.team,
  e.employee_name,
  e.salary,
  COALESCE(SUM(p.budget), 0) AS total_worth_of_completed_projects,
  COUNT(*) as completed_projects,
  SUM(CASE WHEN p.end_date IS NOT NULL AND p.end_date <= p.expected_end_date THEN 1 ELSE 0 END) AS timely_completion_score,
    SUM(CASE WHEN p.end_date IS NOT NULL AND p.end_date <= p.expected_end_date THEN 1 ELSE 0 END) AS bonus,
    SUM(CASE WHEN p.end_date IS NOT NULL AND p.end_date <= p.expected_end_date THEN 0 ELSE 0.5 END) AS deductions,
  RANK() OVER (PARTITION BY e.team ORDER BY total_worth_of_completed_projects * (1 + (timely_completion_score * 0.2 + bonus - deductions)) / salary DESC) 
    AS efficiency_rank
FROM employee e
inner JOIN projects p ON e.employee_id = p.employee_id
GROUP BY e.team, e.employee_name, e.salary;

-- Final Query
WITH EfficiencyData AS (
    SELECT
        e.team,
        e.employee_name,
        e.salary,
        COALESCE(SUM(p.budget), 0) AS total_worth_of_completed_projects,
        COUNT(p.project_name) AS completed_projects,
        SUM(CASE WHEN p.end_date IS NOT NULL AND p.end_date <= p.expected_end_date THEN 1 ELSE 0 END) AS timely_completion_score,
        SUM(CASE WHEN p.end_date IS NOT NULL AND p.end_date <= p.expected_end_date THEN 1 ELSE 0 END) AS bonus,
        SUM(CASE WHEN p.end_date IS NOT NULL AND p.end_date <= p.expected_end_date THEN 0 ELSE 0.5 END) AS deductions,
        RANK() OVER (PARTITION BY e.team ORDER BY total_worth_of_completed_projects * (1 + (timely_completion_score * 0.2 + bonus - deductions)) / salary DESC) 
      AS efficiency_rank
    FROM employee e
    INNER JOIN projects p ON e.employee_id = p.employee_id
    GROUP BY e.team, e.employee_name, e.salary
)
SELECT
    team,
    employee_name,
    ROUND((total_worth_of_completed_projects * (1 + (timely_completion_score * 0.2 + bonus - deductions)) / salary), 2) AS efficiency_score
FROM EfficiencyData
WHERE efficiency_rank = 1;



