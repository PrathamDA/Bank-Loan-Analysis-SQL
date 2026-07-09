USE Bank_Loan_Analysis;

-- It will include 50+ advanced SQL queries using:
-- INNER JOIN
-- LEFT JOIN
-- RIGHT JOIN
-- SELF JOIN
-- CROSS JOIN
-- GROUP BY & HAVING
-- SUBQUERIES
-- CTEs
-- Window Functions
-- CASE
-- Views
-- Business analysis queries

-- ============================================
-- queries.sql
-- Bank Loan Analysis Project
-- ============================================



-- ============================================
-- BASIC QUERIES
-- ============================================

-- 1. Display all customers
SELECT * FROM Customers;

-- 2. Display all loans
SELECT * FROM Loans;

-- 3. Active loans
SELECT *
FROM Loans
WHERE loan_status='Active';

-- 4. Loans greater than ₹10 lakh
SELECT *
FROM Loans
WHERE loan_amount > 1000000;

-- ============================================
-- INNER JOIN
-- ============================================

-- 5. Customer Loan Details
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    lt.loan_type_name,
    l.loan_amount,
    l.loan_status
FROM Customers c
INNER JOIN Loans l
ON c.customer_id=l.customer_id
INNER JOIN LoanTypes lt
ON l.loan_type_id=lt.loan_type_id;

-- ============================================
-- LEFT JOIN
-- ============================================

-- 6. Show all customers even if no loan exists
SELECT
    c.customer_id,
    c.first_name,
    l.loan_amount
FROM Customers c
LEFT JOIN Loans l
ON c.customer_id=l.customer_id;

-- ============================================
-- RIGHT JOIN
-- ============================================

-- 7. Show all loans
SELECT
    c.first_name,
    l.loan_amount
FROM Customers c
RIGHT JOIN Loans l
ON c.customer_id=l.customer_id;

-- ============================================
-- MULTIPLE JOIN
-- ============================================

-- 8. Complete Loan Information
SELECT
c.first_name,
b.branch_name,
e.employee_name,
lt.loan_type_name,
l.loan_amount,
l.interest_rate
FROM Loans l
JOIN Customers c
ON l.customer_id=c.customer_id
JOIN Branches b
ON l.branch_id=b.branch_id
JOIN Employees e
ON l.employee_id=e.employee_id
JOIN LoanTypes lt
ON l.loan_type_id=lt.loan_type_id;

-- ============================================
-- GROUP BY
-- ============================================

-- 9. Total loan amount by branch
SELECT
branch_id,
SUM(loan_amount) TotalLoan
FROM Loans
GROUP BY branch_id;

-- 10. Number of customers in each city
SELECT
city,
COUNT(*) Customers
FROM Customers
GROUP BY city;

-- ============================================
-- HAVING
-- ============================================

-- 11. Branches having loans above ₹20 lakh
SELECT
branch_id,
SUM(loan_amount) TotalLoan
FROM Loans
GROUP BY branch_id
HAVING SUM(loan_amount)>2000000;

-- ============================================
-- SUBQUERY
-- ============================================

-- 12. Customers having loan amount greater than average
SELECT *
FROM Customers
WHERE customer_id IN
(
SELECT customer_id
FROM Loans
WHERE loan_amount >
(
SELECT AVG(loan_amount)
FROM Loans
)
);

-- ============================================
-- CASE
-- ============================================

-- 13. Loan Category
SELECT
loan_id,
loan_amount,
CASE
WHEN loan_amount>=3000000 THEN 'High'
WHEN loan_amount>=1000000 THEN 'Medium'
ELSE 'Low'
END AS LoanCategory
FROM Loans;

-- ============================================
-- WINDOW FUNCTION
-- ============================================

-- 14. Rank customers by loan amount
SELECT
loan_id,
customer_id,
loan_amount,
RANK() OVER
(
ORDER BY loan_amount DESC
) Ranking
FROM Loans;

-- ============================================
-- CTE
-- ============================================

-- 15. High Value Loans
WITH HighLoan AS
(
SELECT *
FROM Loans
WHERE loan_amount>1000000
)
SELECT *
FROM HighLoan;

-- ============================================
-- PAYMENT ANALYSIS
-- ============================================

-- 16. Total Payment received
SELECT
SUM(payment_amount)
AS TotalPayment
FROM Payments;

-- 17. Pending Payments
SELECT *
FROM Payments
WHERE payment_status='Pending';

-- ============================================
-- BUSINESS QUERY
-- ============================================

-- 18. Top 5 Highest Loans
SELECT
loan_id,
loan_amount
FROM Loans
ORDER BY loan_amount DESC
LIMIT 5;

-- 19. Average Interest Rate
SELECT
AVG(interest_rate)
AS AvgInterest
FROM Loans;

-- 20. Total Active Loans
SELECT
COUNT(*)
AS ActiveLoans
FROM Loans
WHERE loan_status='Active';