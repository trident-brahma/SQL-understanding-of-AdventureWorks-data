-- Write a Procedure supplying name information from the Person.Person table and accepting a filter for the first name. Alter the above Store Procedure to supply Default Values if user does not enter any value. ( Use AdventureWorks)

CREATE PROCEDURE Person.NameInformation
	@Name nvarchar(50)
AS
SELECT FirstName, MiddleName, LastName
FROM Person.Person
WHERE FirstName = @Name
GO

ALTER PROCEDURE Person.NameInformation
	@Name nvarchar(50)
AS
IF @Name IS NULL BEGIN;
	SET @Name = 'AdventureWorks'
END;

SELECT FirstName, MiddleName, LastName
FROM Person.Person
WHERE FirstName = @Name