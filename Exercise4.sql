-- Create a function that takes as inputs a SalesOrderID, a Currency Code, and a date, and returns a table of all the SalesOrderDetail rows for that Sales Order including Quantity, ProductID, UnitPrice, and the unit price converted to the target currency based on the end of day rate for the date provided. Exchange rates can be found in the Sales.CurrencyRate table. (Use AdventureWorks)

CREATE FUNCTION dbo.ufnGetSalesOrderDetail (
	@SalesOrderID INT,
	@ToCurrencyCode nChar(3),
	@CurrencyRateDate DATETIME)

RETURNS @retSalesOrderDetails TABLE(
	SalesOrderDetailID INT,
	OrderQty SMALLINT,
	ProductID INT,
	UnitPrice MONEY,
	UnitPriceConverted MONEY)
AS
BEGIN

DECLARE @EndOfDayRate MONEY;

SELECT @EndOfDayRate = EndOfDayRate
FROM Sales.CurrencyRate
WHERE CurrencyRateDate = @CurrencyRateDate
AND ToCurrencyCode = @ToCurrencyCode

INSERT @retSalesOrderDetails

SELECT SalesOrderDetailID, OrderQty, ProductID, UnitPrice, UnitPrice * @EndOfDayRate
FROM Sales.SalesOrderDetail
WHERE SalesOrderID = @SalesOrderID

RETURN;

END
GO

SELECT * FROM dbo.ufnGetSalesOrderDetail(43659, 'ARS', '2005-07-01 00:00:00.000')