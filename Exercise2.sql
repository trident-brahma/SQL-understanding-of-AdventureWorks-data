--Write separate queries using a join, a subquery, a CTE, and then an EXISTS to list all AdventureWorks customers who have not placed an order.
USE AdventureWorks2008R2

-- using join
SELECT p.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName
FROM Person.Person AS p
LEFT JOIN Sales.Customer AS c
ON p.BusinessEntityID = c.PersonID
LEFT JOIN Sales.SalesOrderHeader as soh
ON c.CustomerID = soh.CustomerID
WHERE soh.SalesOrderID IS NULL;

 -- using SUBQUERY
SELECT p.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName
FROM Person.Person AS p
WHERE p.BusinessEntityID NOT IN (
	SELECT c.PersonID
	FROM Sales.Customer AS c
	JOIN Sales.SalesOrderHeader as soh
	ON c.CustomerID = soh.CustomerID);
	
-- using CTE
WITH Customers (BusinessEntityID)
AS (
	SELECT c.PersonID
	FROM Sales.Customer AS c
	JOIN Sales.SalesOrderHeader as soh
	ON c.CustomerID = soh.CustomerID)
SELECT p.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName
FROM Person.Person AS p
LEFT JOIN Customers as cc
ON cc.BusinessEntityID = p.BusinessEntityID
WHERE cc.BusinessEntityID IS NULL;

-- using EXISTS
SELECT p.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName
FROM Person.Person AS p
WHERE NOT EXISTS (
	SELECT *
	FROM Sales.Customer AS c
	JOIN Sales.SalesOrderHeader AS soh
	ON c.CustomerID = soh.CustomerID
	WHERE c.PersonID = p.BusinessEntityID);