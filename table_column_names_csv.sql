-- table_column_names_csv - return table column names as csv
-- usage: 
    -- DECLARE @cols_csv nvarchar(max)
    -- EXECUTE @from_cols_csv = dbo.table_column_names_csv @FromTable, @Sort=1, @Desc=0
-- Home: https://github.com/JavaScriptDude/SQLStuff
-- Author: Timothy C. Quinn
USE <db>
GO
CREATE FUNCTION dbo.table_column_names_csv (
    @TableName sysname -- Table to retrieve Column Count
   ,@Sort bit = 0
   ,@Desc bit = 0
)

RETURNS NVARCHAR(MAX)

AS

BEGIN

    DECLARE @sql nvarchar(max)
    Declare @cols nvarchar(max)
    set @sql = 'SELECT @cols = ISNULL(@cols, '''') + COLUMN_NAME + '', '' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=''' + @TableName + ''''


	Declare @sort_ord varchar(4)
	set @sort_ord = IIF(@Desc = 1, 'DESC', 'ASC')

	if (@Sort = 1)
		begin
			set @sql = @sql + ' ORDER BY COLUMN_NAME ' + @sort_ord
		end


    EXEC sp_executesql @Query = @sql
                     , @Params = N'@cols nvarchar(max) OUT'
                     , @cols = @cols OUT

	--set @cols = trim(@cols)
	set @cols = left(@cols, len(@cols)-1)

    return @cols

END

GO