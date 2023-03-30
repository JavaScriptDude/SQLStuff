-- table_column_count - return number of columns in a table
-- usage: 
    -- DECLARE @cols INT
    -- EXECUTE @cols = dbo.table_column_count @TableName
-- Home: https://github.com/JavaScriptDude/SQLStuff
-- Author: Timothy C. Quinn

USE <db>
GO

CREATE FUNCTION dbo.table_column_count (
    @sTableName sysname -- Table to retrieve Column Count
)

RETURNS INT -- Row count of the table, NULL if not found.

AS

BEGIN

    DECLARE @nColCount INT -- the column count

    DECLARE @nObjectID int -- Object ID

    SET @nObjectID = OBJECT_ID(@sTableName)

    -- Object might not be found

    IF @nObjectID is null RETURN NULL

    SELECT TOP 1 @nColCount = count(column_name)

        FROM information_schema.columns

        where table_name=@sTableName

    RETURN @nColCount

END

GO