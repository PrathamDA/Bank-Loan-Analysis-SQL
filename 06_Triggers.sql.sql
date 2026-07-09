
-- triggers.sql
-- Bank Loan Analysis Project

USE Bank_Loan_Analysis;

-- Audit Table


CREATE TABLE LoanAudit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    action_type VARCHAR(20),
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$


-- Trigger 1 : Validate Loan Amount

CREATE TRIGGER trg_validate_loan_amount
BEFORE INSERT
ON Loans
FOR EACH ROW
BEGIN
    IF NEW.loan_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Loan Amount must be greater than zero';
    END IF;
END$$


-- Trigger 2 : Validate Interest Rate

CREATE TRIGGER trg_validate_interest
BEFORE INSERT
ON Loans
FOR EACH ROW
BEGIN
    IF NEW.interest_rate < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Invalid Interest Rate';
    END IF;
END$$


-- Trigger 3 : Audit Loan Status

CREATE TRIGGER trg_loan_status_update
AFTER UPDATE
ON Loans
FOR EACH ROW
BEGIN
    IF OLD.loan_status <> NEW.loan_status THEN

        INSERT INTO LoanAudit
        (
            loan_id,
            action_type,
            old_status,
            new_status
        )
        VALUES
        (
            NEW.loan_id,
            'STATUS UPDATE',
            OLD.loan_status,
            NEW.loan_status
        );

    END IF;
END$$


-- Trigger 4 : Payment Validation

CREATE TRIGGER trg_validate_payment
BEFORE INSERT
ON Payments
FOR EACH ROW
BEGIN
    IF NEW.payment_amount <=0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Payment Amount cannot be zero';

    END IF;
END$$


-- Trigger 5 : Prevent Customer Delete

CREATE TRIGGER trg_customer_delete
BEFORE DELETE
ON Customers
FOR EACH ROW
BEGIN

    IF EXISTS
    (
        SELECT 1
        FROM Loans
        WHERE customer_id=OLD.customer_id
    )

    THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Customer has Loan Record';

    END IF;

END$$


-- Trigger 6 : Default Loan Status

CREATE TRIGGER trg_default_status
BEFORE INSERT
ON Loans
FOR EACH ROW
BEGIN

    IF NEW.loan_status IS NULL THEN

        SET NEW.loan_status='Pending';

    END IF;

END$$


-- Trigger 7 : Payment Audit

CREATE TABLE PaymentAudit
(
audit_id INT AUTO_INCREMENT PRIMARY KEY,
payment_id INT,
payment_amount DECIMAL(12,2),
payment_status VARCHAR(20),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER trg_payment_insert
AFTER INSERT
ON Payments
FOR EACH ROW
BEGIN

INSERT INTO PaymentAudit
(
payment_id,
payment_amount,
payment_status
)

VALUES
(
NEW.payment_id,
NEW.payment_amount,
NEW.payment_status
);

END$$


-- Trigger 8 : Customer Email Validation

CREATE TRIGGER trg_email_validation
BEFORE INSERT
ON Customers
FOR EACH ROW
BEGIN

IF NEW.email NOT LIKE '%@%' THEN

SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Invalid Email Address';

END IF;

END$$


-- Trigger 9 : Credit Score Validation

CREATE TRIGGER trg_credit_score
BEFORE INSERT
ON Customers
FOR EACH ROW
BEGIN

IF NEW.credit_score<300
OR NEW.credit_score>900 THEN

SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Credit Score must be between 300 and 900';

END IF;

END$$


-- Trigger 10 : Auto Payment Status

CREATE TRIGGER trg_auto_payment
BEFORE INSERT
ON Payments
FOR EACH ROW
BEGIN

IF NEW.payment_amount>0 THEN

SET NEW.payment_status='Paid';

END IF;

END$$

DELIMITER ;

SHOW TRIGGERS;
-- End of triggers.sql
