--MOTOR VEHICLE THEFT
--View all table
SELECT * FROM locations;
SELECT * FROM make_details;
SELECT * FROM stolen_vehicles;

--1.On what day of the week are vehicles most often and least often stolen?
SELECT 
    DATENAME(WEEKDAY, CAST(date_stolen AS DATE)) AS day_of_week,
    COUNT(*) AS total_stolen
FROM 
    stolen_vehicles
GROUP BY 
    DATENAME(WEEKDAY, CAST(date_stolen AS DATE))
ORDER BY 
    total_stolen DESC;

--2.What types of vehicles are most often and least often stolen? Does this vary by region?
	SELECT 
    l.region,
    sv.vehicle_type,
    COUNT(*) AS total_stolen
FROM 
    stolen_vehicles sv
JOIN 
    locations l ON sv.location_id = l.location_id
GROUP BY 
    l.region, 
    sv.vehicle_type
ORDER BY 
    l.region, 
    total_stolen DESC;

	--3.What is the average age of the vehicles that are stolen? Does this vary based on the vehicle type?
	SELECT 
    vehicle_type,
    AVG(YEAR(GETDATE()) - model_year) AS average_age
FROM 
    stolen_vehicles
GROUP BY 
    vehicle_type
ORDER BY 
    average_age DESC;

	--4.Which regions have the most and least number of stolen vehicles? What are the characteristics of these regions?
	SELECT 
    l.region,
    COUNT(sv.vehicle_id) AS total_stolen
FROM 
    stolen_vehicles sv
JOIN 
    locations l ON sv.location_id = l.location_id
GROUP BY 
    l.region
ORDER BY 
    total_stolen DESC;

--MICROFINANCE BANK
--CREATE TABLES
--Customer table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    date_of_birth DATE NOT NULL,
    location VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15) UNIQUE,
    registration_date DATE NOT NULL,
    exit_date DATE NULL);

 INSERT INTO Customers (name, gender, date_of_birth, location, email, phone_number, registration_date, exit_date)
VALUES 
('John Doe', 'M', '1985-05-20', 'New York', 'john.doe@example.com', '1234567890', '2023-01-01', NULL),
('Jane Smith', 'F', '1990-09-12', 'Los Angeles', 'jane.smith@example.com', '0987654321', '2023-02-01', NULL),
('Alice Johnson', 'F', '1982-03-15', 'Chicago', 'alice.j@example.com', '1122334455', '2023-03-01', NULL),
('Bob Brown', 'M', '1978-07-22', 'Houston', 'bob.b@example.com', '2233445566', '2023-04-01', NULL),
('Charlie Davis', 'M', '1988-11-30', 'Phoenix', 'charlie.d@example.com', '3344556677', '2023-05-01', NULL),
('Eva White', 'F', '1995-02-17', 'Philadelphia', 'eva.w@example.com', '4455667788', '2023-06-01', NULL),
('Frank Harris', 'M', '1983-06-10', 'San Antonio', 'frank.h@example.com', '5566778899', '2023-07-01', NULL),
('Grace Lee', 'F', '1992-08-25', 'San Diego', 'grace.l@example.com', '6677889900', '2023-08-01', NULL),
('Henry Clark', 'M', '1981-12-05', 'Dallas', 'henry.c@example.com', '7788990011', '2023-09-01', NULL),
('Isabella King', 'F', '1993-10-18', 'San Jose', 'isabella.k@example.com', '8899001122', '2023-10-01', NULL);

--Bank transaction table
CREATE TABLE BankTransactions (
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    transaction_date DATETIME NOT NULL,
    transaction_type VARCHAR(10) CHECK (transaction_type IN ('credit', 'debit')),
    transaction_detail VARCHAR(50) CHECK (transaction_detail IN ('incoming transfer', 'bill payment', 'outgoing transfer')),
    amount DECIMAL(18, 2) NOT NULL,
    status VARCHAR(10) CHECK (status IN ('failed', 'successful')));

INSERT INTO BankTransactions (customer_id, transaction_date, transaction_type, transaction_detail, amount, status)
VALUES 
(1, '2023-01-10 10:00:00', 'credit', 'incoming transfer', 500.00, 'successful'),
(2, '2023-02-15 12:30:00', 'debit', 'bill payment', 150.00, 'successful'),
(3, '2023-03-20 14:00:00', 'credit', 'incoming transfer', 300.00, 'successful'),
(4, '2023-04-25 16:45:00', 'debit', 'outgoing transfer', 200.00, 'failed'),
(5, '2023-05-30 09:20:00', 'credit', 'incoming transfer', 1000.00, 'successful'),
(6, '2023-06-05 11:15:00', 'debit', 'bill payment', 75.00, 'successful'),
(7, '2023-07-10 13:40:00', 'debit', 'outgoing transfer', 500.00, 'successful'),
(8, '2023-08-15 15:30:00', 'credit', 'incoming transfer', 750.00, 'successful'),
(9, '2023-09-20 10:05:00', 'debit', 'bill payment', 120.00, 'failed'),
(10, '2023-10-25 17:55:00', 'credit', 'incoming transfer', 400.00, 'successful');

--Loan table
CREATE TABLE Loans (
    loan_id INT PRIMARY KEY IDENTITY(1,1),
    loan_date DATE NOT NULL,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    amount DECIMAL(18, 2) NOT NULL,
    due_date DATE NOT NULL);

INSERT INTO Loans (loan_date, customer_id, amount, due_date)
VALUES 
('2023-01-05', 1, 5000.00, '2023-12-05'),
('2023-02-10', 2, 3000.00, '2024-01-10'),
('2023-03-15', 3, 7000.00, '2024-02-15'),
('2023-04-20', 4, 2500.00, '2024-03-20'),
('2023-05-25', 5, 4500.00, '2024-04-25'),
('2023-06-30', 6, 6000.00, '2024-05-30'),
('2023-07-05', 7, 3500.00, '2024-06-05'),
('2023-08-10', 8, 8000.00, '2024-07-10'),
('2023-09-15', 9, 4000.00, '2024-08-15'),
('2023-10-20', 10, 5500.00, '2024-09-20');

--Loan payment
CREATE TABLE LoanPayments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    loan_id INT FOREIGN KEY REFERENCES Loans(loan_id),
    payment_date DATE NOT NULL);

INSERT INTO LoanPayments (loan_id, payment_date)
VALUES 
(1, '2023-02-05'),
(2, '2023-03-10'),
(3, '2023-04-15'),
(4, '2023-05-20'),
(5, '2023-06-25'),
(6, '2023-07-30'),
(7, '2023-08-05'),
(8, '2023-09-10'),
(9, '2023-10-15'),
(10, '2023-11-20');

--1.CASE WHEN 
--1a. On time payment: when the payment date is not greater than the due date
SELECT 
    c.name AS customer_name,
    l.loan_id,
    l.amount AS loan_amount,
    l.due_date,
    lp.payment_date,
    CASE 
        WHEN lp.payment_date <= l.due_date THEN 'On Time'
        ELSE 'Late'
    END AS payment_status
FROM 
    Loans l
JOIN 
    LoanPayments lp ON l.loan_id = lp.loan_id
JOIN 
    Customers c ON l.customer_id = c.customer_id
ORDER BY 
    c.name, l.loan_id;

--1b.Late payment: when the payment that is greater than the due date
SELECT 
    c.name AS customer_name,
    l.loan_id,
    l.amount AS loan_amount,
    l.due_date,
    lp.payment_date,
    CASE 
        WHEN lp.payment_date > l.due_date THEN 'Late'
        ELSE 'On Time'
    END AS payment_status
FROM 
    Loans l
JOIN 
    LoanPayments lp ON l.loan_id = lp.loan_id
JOIN 
    Customers c ON l.customer_id = c.customer_id
ORDER BY 
    c.name, l.loan_id;

--1c. Overdue: when the payment date is null and the current date is greater than the due date
SELECT 
    c.name AS customer_name,
    l.loan_id,
    l.amount AS loan_amount,
    l.due_date,
    lp.payment_date,
    CASE 
        WHEN lp.payment_date IS NULL AND GETDATE() > l.due_date THEN 'Overdue'
        ELSE 'Not Overdue'
    END AS payment_status
FROM 
    Loans l
LEFT JOIN 
    LoanPayments lp ON l.loan_id = lp.loan_id
JOIN 
    Customers c ON l.customer_id = c.customer_id
ORDER BY 
    c.name, l.loan_id;

--2.Write a query to get the total number of customers based on the their loan status
WITH LoanStatus AS (
    SELECT 
        c.customer_id,
        c.name AS customer_name,
        CASE 
            WHEN lp.payment_date IS NULL AND GETDATE() > l.due_date THEN 'Overdue'
            WHEN lp.payment_date > l.due_date THEN 'Late'
            WHEN lp.payment_date <= l.due_date THEN 'On Time'
            ELSE 'No Loan'
        END AS loan_status
    FROM 
        Customers c
    LEFT JOIN 
        Loans l ON c.customer_id = l.customer_id
    LEFT JOIN 
        LoanPayments lp ON l.loan_id = lp.loan_id)
SELECT 
    loan_status,
    COUNT(DISTINCT customer_id) AS total_customers
FROM 
    LoanStatus
GROUP BY 
    loan_status;

--3.At least 2 views, which includes a view to see only credit transactions
CREATE VIEW transaction_type 
AS SELECT * FROM BankTransactions 
WHERE transaction_type ='Credit';

--4.At least 2 procedures, which includes a procedure to update customer phone number
CREATE PROCEDURE updatecustomerphonenumber(@customer_id INT,@newphonenumber VARCHAR (15)) AS BEGIN UPDATE Customers SET phone_number = @NewPhoneNumber WHERE customer_id = @customer_id END;GO

EXEC updatecustomerphonenumber customer_id (1), 0122345678;

DROP PROCEDURE IF EXISTS updatecustomerphonenumber;

CREATE PROCEDURE updatecustomerphonenumber(@customer_id INT,@newphonenumber VARCHAR (15)) AS BEGIN UPDATE Customers SET phone_number = @NewPhoneNumber WHERE customer_id = @customer_id END;

EXEC updatecustomerphonenumber 2, 0122345678;

--5.At least 2 functions, which includes a function that returns results for customers living in a specified city (e.g. Ikeja)
CREATE FUNCTION GetCustomersByCity(@City VARCHAR(100))RETURNS TABLE AS RETURN (SELECT location FROM Customers WHERE location = @City);

--to check
SELECT * FROM GetCustomersByCity('Chicago');