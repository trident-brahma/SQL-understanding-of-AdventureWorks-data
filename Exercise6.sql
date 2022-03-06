-- Write a trigger for the Product table to ensure the list price can never be raised more than 15 Percent in a single change. Modify the above trigger to execute its check code only if the ListPrice column is updated (Use AdventureWorks Database).

CREATE TRIGGER Production.trgNoPriceChange
ON Production.Product
FOR UPDATE
AS
IF EXISTS (
	SELECT * FROM inserted AS i
	JOIN deleted AS d
	ON i.ProductID = d.ProductID
	WHERE i.ListPrice > (d.ListPrice * 1.15))
BEGIN
RAISERROR('Price can never be raised more than 15 percent.', 16,1)
ROLLBACK TRAN
END
GO

ALTER TRIGGER Production.trgNoPriceChange
ON Production.Product
FOR UPDATE
AS
IF UPDATE(ListPrice)
BEGIN
IF EXISTS(
	SELECT * FROM inserted AS i
	JOIN deleted AS d
	on i.ProductID = d.ProductID
	WHERE i.ListPrice > (d.ListPrice * 1.15))
BEGIN
RAISERROR ('Price can never be raised more than 15 percent.', 16,1)
ROLLBACK TRAN
END
END
GO