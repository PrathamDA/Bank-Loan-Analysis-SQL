-- BANK LOAN ANALYSIS DATABASE
-- Schema.sql


-- ==================================================================

CREATE DATABASE Bank_Loan_Analysis;
USE Bank_Loan_Analysis;

-- BRANCHES TABLE

CREATE TABLE Branches (
 branch_id INT PRIMARY KEY AUTO_INCREMENT,
 branch_name VARCHAR (100) NOT NULL,
 city VARCHAR (50),
 state VARCHAR (50)
 );
 
 
 -- LOAN TYPES TABLE
 
 CREATE TABLE LoanTypes (
 loan_type_id INT PRIMARY KEY AUTO_INCREMENT,
 loan_type_name VARCHAR (50) NOT NULL,
 default_interest_rate DECIMAL (5,2)
 );
 
 
 -- CUSTOMERS TABLE
 
 CREATE TABLE Customers (
 customer_id INT PRIMARY KEY AUTO_INCREMENT,
 first_name VARCHAR (50),
 last_name VARCHAR (50),
 gender CHAR (1),
 date_of_birth DATE,
 phone VARCHAR (15) UNIQUE, 
 email VARCHAR (100) UNIQUE,
 city VARCHAR (50),
 state VARCHAR (50),
 credit_score int
 );
 
 
 -- EMPLOYEES TABLE
 
 CREATE TABLE Employees (
 employee_id INT PRIMARY KEY AUTO_INCREMENT,
 employee_name VARCHAR (100),
 designation VARCHAR (50),
 branch_id INT,
 hire_date DATE,
 FOREIGN KEY (branch_id) REFERENCES Branches (branch_id)
 );
 
 
 -- LOAN TABLE
 
 CREATE TABLE Loans (
 loan_id INT PRIMARY KEY AUTO_INCREMENT,
 customer_id INT,
 loan_type_id INT,
 branch_id INT,
 employee_id INT,
 loan_amount DECIMAL (12,2),
 interest_rate DECIMAL (5,2),
 tenure_months INT,
 loan_status VARCHAR (20),
 loan_date DATE,
 FOREIGN KEY (customer_id) REFERENCES Customers (customer_id),
 FOREIGN KEY (loan_type_id) REFERENCES LoanTypes (loan_type_id),
 FOREIGN KEY (branch_id) REFERENCES Branches (branch_id),
 FOREIGN KEY (employee_id) REFERENCES Employees (employee_id)
); 


-- PAYMENT TABLE 

CREATE TABLE Payments (
payment_id INT PRIMARY KEY AUTO_INCREMENT,
loan_id INT,
payment_date DATE,
payment_amount DECIMAL (12,2),
payment_mode VARCHAR (30),
payment_status VARCHAR (20),
FOREIGN KEY (loan_id) REFERENCES Loans (loan_id)
);


-- INDEXES 

CREATE INDEX idx_customer_city ON Customers (city);
CREATE INDEX idx_loan_status ON Loans (loan_status);
CREATE INDEX idx_payment_date ON Payments (payment_date);

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 