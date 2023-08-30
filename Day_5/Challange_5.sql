# Challenge-05

create database average_payment;
use average_payment;

/*Now, we want to find out the average payment amount received from customers who are currently active subscribers and have renewed their subscription 
during the month of July 2023. Since customers worldwide pay in their local currencies, we need to convert the payment amounts to USD (United States Dollars) for analysis.

For instance, if a customer is from Canada and paid in Canadian Dollars (CAD), we will convert their payment amount to USD using the exchange rate of 1 CAD = 1.25 USD.
 Similarly, for customers from the UK paying in British Pounds (GBP), we will convert their payment amount to USD using the exchange rate of 1 GBP = 0.8 USD, 
 and so on for other currencies. The exchange rates are as follows:
1 EUR (Euro) = 0.9 USD (USD to EUR)
1 JPY (Japanese Yen) = 110.0 USD (USD to JPY)
1 INR (Indian Rupee) = 81.0 USD (USD to INR)*/

/* Q-The final output will show the customer_id and their average payment amount in both USD and the customer's local currency, 
along with the exchange rate used for the conversion.
If a customer's local currency is USD, the average payment amount in their currency will be the same as the average payment in USD, and the exchange rate will be 1.0.
*/

-- Changing renewal_date column from TEXT to DATE format in subscription table

ALTER TABLE subscriptions
ADD COLUMN new_renewal_date DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE subscriptions
SET new_renewal_date = STR_TO_DATE(renewal_date, "%d-%m-%Y");

ALTER TABLE subscriptions
DROP COLUMN renewal_date;

ALTER TABLE subscriptions
RENAME COLUMN new_renewal_date TO renewal_date;

SELECT * FROM subscriptions;

-- Changing payment_date column from TEXT to DATE format in payment table

SELECT * FROM payments;

ALTER TABLE payments
ADD COLUMN new_payment_date DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE payments
SET new_payment_date = STR_TO_DATE(payment_date, "%Y-%m-%d");

ALTER TABLE payments
DROP COLUMN payment_date;

ALTER TABLE payments
RENAME COLUMN new_payment_date TO payment_date;

SELECT * FROM payments;

/* Q-The final output will show the customer_id and their average payment amount in both USD and the customer's local currency, 
along with the exchange rate used for the conversion.
If a customer's local currency is USD, the average payment amount in their currency will be the same as the average payment in USD, and the exchange rate will be 1.0.
*/
SELECT * FROM customers;
SELECT * FROM subscriptions;
SELECT * FROM payments;


select 
    c.customer_id,
    c.currency as local_currency,
    avg(p.amount) as average_payment_in_local_currency,
    round(avg(
        case 
            when c.currency = 'USD' then p.amount
            when c.currency = 'CAD' then p.amount / 1.25
            when c.currency = 'GBP' then p.amount / 0.8
            when c.currency = 'EUR' then p.amount / 0.9
            when c.currency = 'JPY' then p.amount / 110
            when c.currency = 'INR' then p.amount / 81
        end
    ),2) as average_payment_in_usd,
    case 
        when c.currency = 'USD' then 1.0
        when c.currency = 'CAD' then 1.25
        when c.currency = 'GBP' then 0.8
        when c.currency = 'EUR' then 0.9
        when c.currency = 'JPY' then 110
        when c.currency = 'INR' then 81
    end as exchange_rate
from
    Customers c
    inner join Subscriptions s on c.customer_id = s.customer_id
    inner join Payments p on s.subscription_id = p.subscription_id
where
    c.subscription_status = 'active'
    and s.renewal_date >= '2023-07-01'
    and s.renewal_date < '2023-08-01'
group by
    c.customer_id,
    c.currency,
    exchange_rate;
    
