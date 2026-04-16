-- =========================
-- DATABASE
-- =========================
CREATE DATABASE DataTransformer;
USE DataTransformer;

-- =========================
-- 1. CUSTOMERS TABLE
-- =========================
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);

INSERT INTO Customers VALUES
(1, 'Amit', 'Sharma', 'amit@gmail.com', '2022-01-10'),
(2, 'Priya', 'Patel', 'priya@gmail.com', '2021-05-22'),
(3, 'Rahul', 'Verma', 'rahul@gmail.com', '2023-03-15'),
(4, 'Sneha', 'Reddy', 'sneha@gmail.com', '2020-11-01'),
(5, 'Karan', 'Mehta', 'karan@gmail.com', '2022-07-19'),
(6, 'Neha', 'Kapoor', 'neha@gmail.com', '2021-09-25'),
(7, 'Vikas', 'Singh', 'vikas@gmail.com', '2023-02-10'),
(8, 'Anjali', 'Gupta', 'anjali@gmail.com', '2020-06-30'),
(9, 'Rohit', 'Yadav', 'rohit@gmail.com', '2022-12-05'),
(10, 'Pooja', 'Nair', 'pooja@gmail.com', '2021-08-18');

-- =========================
-- 2. ORDERS TABLE
-- =========================
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(101, 1, '2023-07-01', 1200),
(102, 2, '2023-07-05', 800),
(103, 3, '2023-07-07', 1500),
(104, 4, '2023-07-10', 400),
(105, 5, '2023-07-12', 2000),
(106, 6, '2023-07-15', 600),
(107, 7, '2023-07-18', 3000),
(108, 8, '2023-07-20', 750),
(109, 9, '2023-07-22', 1800),
(110, 10, '2023-07-25', 950);

-- =========================
-- 3. EMPLOYEES TABLE
-- =========================
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);

INSERT INTO Employees VALUES
(1, 'Arjun', 'Desai', 'Sales', '2019-02-10', 48000),
(2, 'Meera', 'Joshi', 'HR', '2020-04-15', 52000),
(3, 'Rakesh', 'Kumar', 'IT', '2018-06-20', 60000),
(4, 'Divya', 'Shah', 'Finance', '2021-01-12', 55000),
(5, 'Manish', 'Bansal', 'Sales', '2017-09-30', 45000),
(6, 'Kavita', 'Iyer', 'HR', '2022-03-25', 50000),
(7, 'Suresh', 'Pillai', 'IT', '2016-11-05', 70000),
(8, 'Nikita', 'Agarwal', 'Finance', '2021-07-19', 53000),
(9, 'Deepak', 'Chopra', 'Sales', '2019-12-01', 49000),
(10, 'Ritu', 'Malhotra', 'HR', '2020-08-22', 51000);

-- =========================
-- QUERIES
-- =========================

-- 1. INNER JOIN
SELECT o.OrderID, c.FirstName, c.LastName, o.TotalAmount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 2. LEFT JOIN
SELECT c.FirstName, c.LastName, o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 3. RIGHT JOIN
SELECT o.OrderID, c.FirstName, c.LastName
FROM Orders o
RIGHT JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 4. FULL OUTER JOIN (MySQL workaround)
SELECT c.CustomerID, c.FirstName, o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT c.CustomerID, c.FirstName, o.OrderID
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 5. Customers spending above average
SELECT * FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID FROM Orders
    GROUP BY CustomerID
    HAVING SUM(TotalAmount) > (SELECT AVG(TotalAmount) FROM Orders)
);

-- 6. Employees above average salary
SELECT * FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- 7. Extract year & month
SELECT OrderID,
YEAR(OrderDate) AS Year,
MONTH(OrderDate) AS Month
FROM Orders;

-- 8. Date difference
SELECT OrderID,
DATEDIFF(CURDATE(), OrderDate) AS DaysDifference
FROM Orders;

-- 9. Format date
SELECT OrderID,
DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedDate
FROM Orders;

-- 10. Full name
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;

-- 11. Replace string
SELECT REPLACE(FirstName, 'Amit', 'Amitabh') AS UpdatedName
FROM Customers;

-- 12. Upper & lower case
SELECT UPPER(FirstName) AS UpperName,
LOWER(LastName) AS LowerName
FROM Customers;

-- 13. Trim spaces
SELECT TRIM('   Data Transformer Project   ') AS TrimmedText;

-- 14. Running total
SELECT OrderID,
TotalAmount,
SUM(TotalAmount) OVER (ORDER BY OrderID) AS RunningTotal
FROM Orders;

-- 15. Rank orders
SELECT OrderID,
TotalAmount,
RANK() OVER (ORDER BY TotalAmount DESC) AS RankPosition
FROM Orders;

-- 16. Discount calculation
SELECT OrderID,
TotalAmount,
CASE
    WHEN TotalAmount > 2000 THEN '10% Discount'
    WHEN TotalAmount > 1000 THEN '5% Discount'
    ELSE 'No Discount'
END AS Discount
FROM Orders;

-- 17. Salary category
SELECT EmployeeID,
Salary,
CASE
    WHEN Salary > 60000 THEN 'High'
    WHEN Salary >= 50000 THEN 'Medium'
    ELSE 'Low'
END AS SalaryCategory
FROM Employees;