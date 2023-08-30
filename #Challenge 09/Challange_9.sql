/*
A bank wants to analyze the daily visits and transactions of its customers throughout a month. They have two tables, visit and transaction, with the following details:

1.The visit table records the user visits to the bank. Each row indicates that a user with the given user_id visited the bank on the specified visit_date.
2.The transaction table records transactions made by users. Each row indicates that a user with the given user_id made a transaction of the specified amount on the specified 
transaction_date.

The bank wants to generate a report that displays the daily visits and transactions count for each day within the specified month.
 If there are no visits or transactions on a particular day, the report should still display that day with counts of zero.

Q.Write an SQL query to retrieve the following information for each day:
date: The date of the visit or transaction.
visitors_count: The number of distinct users who visited the bank on that date.
transactions_count: The number of distinct users who made transactions on that date.

The report should be ordered by date.
*/
CREATE DATABASE bank ;

USE bank ;

SELECT * FROM transactions;
SELECT * FROM visits;

-- transactions table test to date conversation

ALTER TABLE transactions
modify column transaction_date DATE;

SET SQL_SAFE_UPDATES = 0;

-- visits  table test to date conversation

ALTER TABLE visits
modify column visit_date DATE;

SET SQL_SAFE_UPDATES = 0;


SELECT * FROM transactions;
SELECT * FROM visits;

WITH cte1 AS (
SELECT 
  visit_date AS  date, 
  COALESCE(COUNT(DISTINCT user_id), 0) AS visitors_count
FROM visits
GROUP BY date
ORDER BY date)
, cte2 AS (
SELECT 
  transaction_date AS date, 
  COALESCE(COUNT(DISTINCT user_id), 0) AS transactions_count
FROM transactions
GROUP BY date
ORDER BY date)
SELECT 
  date,
    visitors_count,
    transactions_count
FROM cte1 
INNER JOIN cte2 USING(date);

-- ———————————————————————————————

SELECT
    date_list.date,
    COALESCE(COUNT(DISTINCT v.user_id), 0) AS visitors_count,
    COALESCE(COUNT(DISTINCT t.user_id), 0) AS transactions_count
FROM (
    SELECT visit_date AS date FROM visits
    UNION
    SELECT transaction_date AS date FROM transactions
    order by  date
  ) AS date_list
LEFT JOIN visits v ON date_list.date = v.visit_date
LEFT JOIN transactions t ON date_list.date = t.transaction_date
GROUP BY date_list.date
ORDER BY date_list.date;
