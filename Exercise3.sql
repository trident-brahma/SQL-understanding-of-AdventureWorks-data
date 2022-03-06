--Show the most recent five orders that were purchased from account numbers that have spent more than $70,000 with AdventureWorks.

WITH HigherRate AS (
	SELECT CustomerID
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID
	HAVING SUM(TotalDue) > 70000),

	Recent AS (
	SELECT soh.CustomerID, soh.SalesOrderID, soh.OrderDate, soh.TotalDue, ROW_NUMBER() OVER (PARTITION BY soh.CustomerID ORDER BY OrderDate DESC) AS RowNum
	FROM Sales.SalesOrderHeader as soh
	JOIN HigherRate AS m
	ON soh.CustomerID = m.CustomerID)

SELECT CustomerID, SalesOrderID, OrderDate, TotalDue
FROM Recent
WHERE RowNum <= 5
ORDER BY CustomerID, RowNum;