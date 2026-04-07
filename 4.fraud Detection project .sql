CREATE DATABASE fraud_detection;
USE fraud_detection;

CREATE TABLE transactions (
    Transaction_ID INT,
    Customer_ID INT,
    Transaction_Amount FLOAT,
    Transaction_Time VARCHAR(50),
    Location VARCHAR(50),
    Payment_Method VARCHAR(50),
    Is_Fraud INT
);
/*1. Check for NULL values*/
SELECT *
FROM transactions
WHERE Transaction_Amount IS NULL
   OR Customer_ID IS NULL;
   
   /*2. Check duplicates*/
   SELECT Transaction_ID, COUNT(*)
FROM transactions
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;

/*3. Check date & time format*/
SELECT Transaction_Time
FROM transactions
LIMIT 10;

UPDATE transactions
SET Transaction_Time = STR_TO_DATE(Transaction_Time, '%d-%m-%Y %H:%i');

ALTER TABLE transactions
MODIFY Transaction_Time DATETIME;

/*1. Detect High-Value Suspicious Transactions*?

SELECT *
FROM transactions
WHERE Transaction_Amount > 30000
ORDER BY Transaction_Amount DESC;

/*2. Find Frequent Transactions in Short Time (Fraud Pattern)*/

SELECT Customer_ID, COUNT(*) AS transaction_count
FROM transactions
WHERE Transaction_Time >= (NOW() - INTERVAL 1 HOUR)
GROUP BY Customer_ID
HAVING COUNT(*) > 5;

/*3. Detect Fraud by Location Pattern*/

SELECT Location, COUNT(*) AS fraud_count
FROM transactions
WHERE Is_Fraud = 1
GROUP BY Location
ORDER BY fraud_count DESC;

/*4. Fraud by Payment Method*/

SELECT Payment_Method, COUNT(*) AS fraud_count
FROM transactions
WHERE Is_Fraud = 1
GROUP BY Payment_Method;

/*5. Identify High-Risk Customers*/

SELECT Customer_ID, COUNT(*) AS fraud_transactions
FROM transactions
WHERE Is_Fraud = 1
GROUP BY Customer_ID
HAVING COUNT(*) > 3
ORDER BY fraud_transactions DESC;

/*6. Transactions at Unusual Time (Night Fraud)*/

SELECT *
FROM transactions
WHERE HOUR(Transaction_Time) BETWEEN 0 AND 5;

/*7. Combine Multiple Fraud Conditions*/

SELECT *,
       CASE 
           WHEN Transaction_Amount > 30000 
                AND HOUR(Transaction_Time) BETWEEN 0 AND 5 
           THEN 'HIGH RISK'
           
           WHEN Transaction_Amount > 20000 
           THEN 'MEDIUM RISK'
           
           ELSE 'LOW RISK'
       END AS Risk_Level
FROM transactions;