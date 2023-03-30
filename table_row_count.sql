-- table_row_count - returns the number of rows in a table
-- usage: 
    -- DECLARE @rows INT
    -- EXECUTE @rows = dbo.table_row_count @TableName
-- Home: https://github.com/JavaScriptDude/SQLStuff
-- Author: Timothy C. Quinn
USE <db>
GO

CREATE FUNCTION dbo.table_row_count (
    @sTableName sysname -- Table to retrieve Row Count
)

RETURNS INT -- Row count of the table, NULL if not found.

AS

BEGIN

    DECLARE @nRowCount INT -- the rows

    DECLARE @nObjectID int -- Object ID

    SET @nObjectID = OBJECT_ID(@sTableName)

    -- Object might not be found

    IF @nObjectID is null RETURN NULL

    SELECT TOP 1 @nRowCount = rows

        FROM sysindexes

        WHERE id = @nObjectID AND indid < 2

    RETURN @nRowCount

END

GO