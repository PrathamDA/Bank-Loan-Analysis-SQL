-- procedures.sql
-- Bank Loan Analysis Project


USE Bank_Loan_Analysis;

DELIMITER $$


-- 1. Get Customer Loan Details

CREATE PROCEDURE GetCustomerLoanDetails(IN p_customer_id INT)
BEGIN
    SELECT
        c.customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        lt.loan_type_name,
        l.loan_amount,
        l.interest_rate,
        l.loan_status
    FROM Customers c
    JOIN Loans l ON c.customer_id=l.customer_id
    JOIN LoanTypes lt ON l.loan_type_id=lt.loan_type_id
    WHERE c.customer_id=p_customer_id;
END$$



-- 2. Branch Loan Report

CREATE PROCEDURE GetBranchLoanReport(IN p_branch_id INT)
BEGIN
    SELECT
        b.branch_name,
        COUNT(l.loan_id) AS TotalLoans,
        SUM(l.loan_amount) AS TotalLoanAmount
    FROM Branches b
    JOIN Loans l
    ON b.branch_id=l.branch_id
    WHERE b.branch_id=p_branch_id
    GROUP BY b.branch_name;
END$$



-- 3. Add Customer

CREATE PROCEDURE AddCustomer(
IN p_first VARCHAR(50),
IN p_last VARCHAR(50),
IN p_gender CHAR(1),
IN p_dob DATE,
IN p_phone VARCHAR(15),
IN p_email VARCHAR(100),
IN p_city VARCHAR(50),
IN p_state VARCHAR(50),
IN p_score INT
)
BEGIN
INSERT INTO Customers
(first_name,last_name,gender,date_of_birth,
phone,email,city,state,credit_score)
VALUES
(p_first,p_last,p_gender,p_dob,
p_phone,p_email,p_city,p_state,p_score);
END$$



-- 4. Update Loan Status

CREATE PROCEDURE UpdateLoanStatus(
IN p_loan_id INT,
IN p_status VARCHAR(20)
)
BEGIN
UPDATE Loans
SET loan_status=p_status
WHERE loan_id=p_loan_id;
END$$



-- 5. Customer Payment History

CREATE PROCEDURE CustomerPaymentHistory(
IN p_customer_id INT
)
BEGIN
SELECT
CONCAT(c.first_name,' ',c.last_name) CustomerName,
p.payment_date,
p.payment_amount,
p.payment_status
FROM Customers c
JOIN Loans l
ON c.customer_id=l.customer_id
JOIN Payments p
ON l.loan_id=p.loan_id
WHERE c.customer_id=p_customer_id;
END$$



-- 6. Top 5 Customers

CREATE PROCEDURE TopCustomers()
BEGIN
SELECT
customer_id,
SUM(loan_amount) TotalLoan
FROM Loans
GROUP BY customer_id
ORDER BY TotalLoan DESC
LIMIT 5;
END$$



-- 7. Monthly Loan Report

CREATE PROCEDURE MonthlyLoanReport()
BEGIN
SELECT
YEAR(loan_date) Year,
MONTH(loan_date) Month,
COUNT(*) TotalLoans,
SUM(loan_amount) TotalAmount
FROM Loans
GROUP BY YEAR(loan_date),
MONTH(loan_date);
END$$



-- 8. Employee Performance

CREATE PROCEDURE EmployeePerformance()
BEGIN
SELECT
e.employee_name,
COUNT(l.loan_id) LoansHandled,
SUM(l.loan_amount) TotalLoan
FROM Employees e
LEFT JOIN Loans l
ON e.employee_id=l.employee_id
GROUP BY e.employee_name;
END$$



-- 9. Search Customer

CREATE PROCEDURE SearchCustomer(
IN p_name VARCHAR(50)
)
BEGIN
SELECT *
FROM Customers
WHERE first_name LIKE CONCAT('%',p_name,'%')
OR last_name LIKE CONCAT('%',p_name,'%');
END$$



-- 10. Loan Type Summary

CREATE PROCEDURE LoanTypeSummary()
BEGIN
SELECT
lt.loan_type_name,
COUNT(l.loan_id) TotalLoans,
SUM(l.loan_amount) TotalAmount
FROM LoanTypes lt
LEFT JOIN Loans l
ON lt.loan_type_id=l.loan_type_id
GROUP BY lt.loan_type_name;
END$$

DELIMITER ;


-- Example Calls


CALL GetCustomerLoanDetails(1);

CALL GetBranchLoanReport(2);

CALL TopCustomers();

CALL MonthlyLoanReport();

CALL EmployeePerformance();

CALL CustomerPaymentHistory(1);

CALL LoanTypeSummary();

CALL SearchCustomer('Rahul');

CALL UpdateLoanStatus(1,'Closed');