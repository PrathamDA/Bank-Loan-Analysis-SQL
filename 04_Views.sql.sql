-- views.sql
-- Bank Loan Analysis Project

USE Bank_Loan_Analysis;


-- 1. Active Loans View

CREATE VIEW vw_active_loans AS
SELECT
    loan_id,
    customer_id,
    loan_amount,
    interest_rate,
    loan_status
FROM Loans
WHERE loan_status='Active';


-- 2. Customer Loan Details View

CREATE VIEW vw_customer_loan_details AS
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    lt.loan_type_name,
    l.loan_amount,
    l.interest_rate,
    l.loan_status
FROM Customers c
JOIN Loans l
ON c.customer_id=l.customer_id
JOIN LoanTypes lt
ON l.loan_type_id=lt.loan_type_id;



-- 3. Branch Loan Summary View

CREATE VIEW vw_branch_summary AS
SELECT
    b.branch_id,
    b.branch_name,
    COUNT(l.loan_id) AS total_loans,
    SUM(l.loan_amount) AS total_loan_amount,
    AVG(l.loan_amount) AS average_loan_amount
FROM Branches b
LEFT JOIN Loans l
ON b.branch_id=l.branch_id
GROUP BY b.branch_id,b.branch_name;



-- 4. Employee Performance View

CREATE VIEW vw_employee_performance AS
SELECT
    e.employee_id,
    e.employee_name,
    COUNT(l.loan_id) AS loans_processed,
    SUM(l.loan_amount) AS total_loan_amount
FROM Employees e
LEFT JOIN Loans l
ON e.employee_id=l.employee_id
GROUP BY e.employee_id,e.employee_name;



-- 5. Payment Summary View

CREATE VIEW vw_payment_summary AS
SELECT
    l.loan_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    SUM(p.payment_amount) AS total_paid,
    COUNT(p.payment_id) AS total_payments
FROM Loans l
JOIN Customers c
ON l.customer_id=c.customer_id
LEFT JOIN Payments p
ON l.loan_id=p.loan_id
GROUP BY l.loan_id,c.first_name,c.last_name;



-- 6. Customer Credit Profile View

CREATE VIEW vw_customer_credit AS
SELECT
    customer_id,
    CONCAT(first_name,' ',last_name) AS customer_name,
    credit_score,
    city,
    state
FROM Customers;



-- 7. High Value Loans View

CREATE VIEW vw_high_value_loans AS
SELECT
    loan_id,
    customer_id,
    loan_amount,
    loan_date
FROM Loans

WHERE loan_amount>=1000000;



-- 8. Monthly Loan Report View

CREATE VIEW vw_monthly_loans AS
SELECT
    YEAR(loan_date) AS loan_year,
    MONTH(loan_date) AS loan_month,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_amount
FROM Loans
GROUP BY YEAR(loan_date),MONTH(loan_date);



-- 9. Loan Type Analysis View

CREATE VIEW vw_loan_type_analysis AS
SELECT
    lt.loan_type_name,
    COUNT(l.loan_id) AS total_loans,
    SUM(l.loan_amount) AS total_amount,
    AVG(l.loan_amount) AS avg_amount
FROM LoanTypes lt
LEFT JOIN Loans l
ON lt.loan_type_id=l.loan_type_id
GROUP BY lt.loan_type_name;



-- 10. Complete Banking Report View

CREATE VIEW vw_complete_bank_report AS
SELECT
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    b.branch_name,
    e.employee_name,
    lt.loan_type_name,
    l.loan_amount,
    l.loan_status,
    p.payment_amount,
    p.payment_status
FROM Customers c
JOIN Loans l
ON c.customer_id=l.customer_id
JOIN Branches b
ON l.branch_id=b.branch_id
JOIN Employees e
ON l.employee_id=e.employee_id
JOIN LoanTypes lt
ON l.loan_type_id=lt.loan_type_id
LEFT JOIN Payments p
ON l.loan_id=p.loan_id;


SELECT * FROM vw_LoanDetails;
SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM Loans;
SELECT COUNT(*) FROM Branches;
SELECT COUNT(*) FROM Employees;
SELECT COUNT(*) FROM LoanTypes;