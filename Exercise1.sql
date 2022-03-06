USE AdventureWorks2008R2

-- Display the number of records in the [SalesPerson] table. (Schema(s) involved: Sales)
SELECT COUNT(*) AS Records
FROM Sales.SalesPerson;

-- Select both the FirstName and LastName of records from the Person table where the FirstName begins with the letter ‘B’. (Schema(s) involved: Person)
SELECT FirstName, LastName
FROM Person.Person
WHERE FirstName like 'B%'

-- Select a list of FirstName and LastName for employees where Title is one of Design Engineer, Tool Designer or Marketing Assistant. (Schema(s) involved: HumanResources, Person)
SELECT p.FirstName, p.LastName, e.JobTitle
FROM Person.Person AS p
INNER JOIN HumanResources.Employee AS e
ON p.BusinessEntityID = e.BusinessEntityID
WHERE JobTitle IN ('Design Engineer', 'Tool Designer', 'Marketing Assistant')
ORDER BY p.FirstName, p.LastName;


-- Display the Name and Color of the Product with the maximum weight. (Schema(s) involved: Production)
SELECT Name, Color, Weight
FROM Production.Product
WHERE Weight = (SELECT MAX(Weight) FROM Production.Product)

-- Display Description and MaxQty fields from the SpecialOffer table. Some of the MaxQty values are NULL, in this case display the value 0.00 instead. (Schema(s) involved: Sales)
SELECT Description, ISNULL(MaxQty, 0.00) AS MaxQty
FROM Sales.SpecialOffer

-- Display the overall Average of the [CurrencyRate].[AverageRate] values for the exchange rate ‘USD’ to ‘GBP’ for the year 2005 i.e. FromCurrencyCode = ‘USD’ and ToCurrencyCode = ‘GBP’. Note: The field [CurrencyRate].[AverageRate] is defined as 'Average exchange rate for the day.' (Schema(s) involved: Sales)
SELECT AVG(AverageRate) AS 'Per Day Average'
FROM Sales.CurrencyRate
WHERE FromCurrencyCode = 'USD' and ToCurrencyCode = 'GBP' and year(CurrencyRateDate) = 2005

-- Display the FirstName and LastName of records from the Person table where FirstName contains the letters ‘ss’. Display an additional column with sequential numbers for each row returned beginning at integer 1. (Schema(s) involved: Person)
SELECT ROW_NUMBER() OVER (ORDER BY FirstName) AS ROWNUM, FirstName, LastName
FROM Person.Person
WHERE FirstName LIKE '%ss%'

-- Sales people receive various commission rates that belong to 1 of 4 bands. (Schema(s) involved: Sales)
-- Display the [SalesPersonID] with an additional column entitled ‘Commission Band’ indicating the appropriate band as above.
SELECT BusinessEntityID AS SalesPersonID, CommissionPct,
	CASE WHEN CommissionPct > 0.015 THEN 'Band 3'
		WHEN CommissionPct > 0.01 THEN 'Band 2'
		WHEN CommissionPct > 0.00 THEN 'Band 1'
		ELSE 'Band 0' END AS CommissionBand
FROM Sales.SalesPerson
ORDER BY CommissionPct;

-- Display the managerial hierarchy from Ruth Ellerbrock (person type – EM) up to CEO Ken Sanchez. Hint: use [uspGetEmployeeManagers] (Schema(s) involved: [Person], [HumanResources])
SELECT p.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName, eph.Rate, e.OrganizationLevel, e.JobTitle
FROM HumanResources.Employee AS e
INNER JOIN HumanResources.EmployeePayHistory AS eph
ON e.BusinessEntityID = eph.BusinessEntityID
INNER JOIN Person.Person as p
ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.BusinessEntityID < 49
ORDER BY p.BusinessEntityID;

-- Display the ProductId of the product with the largest stock level. Hint: Use the Scalar-valued function [dbo]. [UfnGetStock]. (Schema(s) involved: Production)
SELECT ProductID, Quantity
FROM Production.ProductInventory
ORDER BY Quantity DESC;