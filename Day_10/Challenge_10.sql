/*
#Challenge 10

Consider a database with three tables: 'trades,' 'salesreps,' and 'clients.' The 'trades' table contains trade information including face value, actual revenue,
 and churn dates for different clients. The 'salesreps' table holds information about sales representatives, including their first and last names. Lastly, the 'clients' table
 stores details about different clients.

In the "trades" table, the column named "churn_date" contains dates when a trade was marked as churned. If the churn date is not null (or not empty), it means the trade has been
 considered as churned. In other words, a "churned" trade is one where the client has decided to end their relationship or service with the company, resulting in the trade being
 marked as no longer active or relevant.

Your task is to identify the top 10 most churned clients based on the number of churned trades. For each of these top churned clients, determine the sales representative(s) 
involved, the total face value, the total actual revenue, and the percentage of face value that is down from revenue for each sales representative. The percentage down from 
revenue is calculated as ((Face Value - Actual Revenue) / Face Value) * 100.

Write a SQL query that accomplishes this. Your query should retrieve the client name, sales representative name(merge first_name and last_name into one column), total face value,
 total actual revenue, and percentage down from revenue for each sales representative. The results should be ordered in descending order based on the percentage down from revenue
 , and only the top 10 results should be displayed.
*/
