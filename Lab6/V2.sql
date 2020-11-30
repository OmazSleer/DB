USE AdventureWorks2012;
GO


/*
		—оздайте хранимую процедуру, котора€ будет возвращать сводную таблицу 
		(оператор PIVOT), отображающую данные о максимальном весе 
		(Production.Product.Weight) продукта в каждой подкатегории 
		(Production.ProductSubcategory) дл€ определенного цвета. 
		—писок цветов передайте в процедуру через входной параметр.
		“аким образом, вызов процедуры будет выгл€деть следующим образом:
		EXECUTE dbo.SubCategoriesByColor С[Black],[Silver],[Yellow]Т
*/
CREATE PROCEDURE SubCategoriesByColor @colors NVARCHAR(MAX)
AS
BEGIN
		DECLARE @query NVARCHAR(MAX);
		SET @query = 'SELECT * 
		FROM 
		(
				SELECT   ps.Name,   p.Weight,   p.Color
							FROM Production.ProductSubcategory AS ps
							INNER JOIN Production.Product AS p
							ON p.ProductSubcategoryID = ps.ProductSubcategoryID
		) AS s
		PIVOT
		(
				MAX(Weight) for Color IN (' +
				@colors
				+ ')
		) piu;';
		EXECUTE sp_executesql  @query;
END;
GO

EXECUTE dbo.SubCategoriesByColor '[Black],[Silver],[Yellow]';
GO