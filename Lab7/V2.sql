USE AdventureWorks2012;
GO


/*
		������� �������� ����� [ProductID], [Name], [ProductNumber] �� ������� 
		[Production].[Product] � ���� xml, ������������ � ����������. ������ 
		xml ������ ��������������� �������.
*/
DECLARE @xml XML;
SET @xml = ( 
		SELECT TOP 2 ProductID AS [@ID], Name, ProductNumber 
		FROM Production.Product
		FOR XML PATH('Product'), ROOT('Products')
);
SELECT @xml;

GO
/*
		������� �������� ���������, ������������ �������, ����������� �� xml 
		���������� ��������������� ����. ������� ��� ��������� ��� ����������� 
		�� ������ ���� ����������.
*/
CREATE PROCEDURE ParseXML(@x XML)
AS
BEGIN
		DECLARE @xml_doc INT;
		EXEC sp_xml_preparedocument @xml_doc OUTPUT, @x;
			SELECT * FROM 
			OPENXML(@xml_doc, '/Products/Product', 2)
				WITH (
						ProductID INT '@ID',
						Name NVARCHAR(50),
						ProductNumber NVARCHAR(50)
				);
			EXEC sp_xml_removedocument @xml_doc;
END;
GO

DECLARE @xml XML;
SET @xml = ( 
		SELECT TOP 2 
			ProductID AS [@ID], 
			Name, 
			ProductNumber 
		FROM Production.Product
		FOR XML PATH('Product'), ROOT('Products')
);
EXECUTE dbo.ParseXML @xml;
GO