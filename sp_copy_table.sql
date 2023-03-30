Use <db>
-- Usage:
	-- Create new table with updated schema
		-- Notes: (must contain all columns from 'FromTable') and target columns must be compatible with source (eg increase # of characters allowed)
	-- Run command:
		-- use <db>
		-- go
		-- EXEC sp_copy_table <source> <dest>
		-- eg: EXEC sp_copy_table 'BT_History', 'BT_History_tmp'
	-- Now you can rename BT_History to BT_History_old and rename BT_History_tmp to BT_History
Go
CREATE PROCEDURE sp_copy_table(
	@FromTable sysname,
	@ToTable sysname
)
AS
BEGIN

	DECLARE @rows INT 
	DECLARE @sql nvarchar(max)
	DECLARE @sql_final nvarchar(max)
	Declare @from_cols_csv nvarchar(max)

	If (@FromTable = @ToTable) BEGIN
		RAISERROR('FromTable and ToTable specified are the same! Exiting', 10, 1, @FromTable); RETURN
	END 

	EXECUTE @from_cols_csv = dbo.table_column_names_csv @FromTable, @Sort=1, @Desc=0

	--RAISERROR('@from_cols_csv = (%s). Exiting', 10, 1, @from_cols_csv); RETURN


	EXECUTE @rows = dbo.table_row_count @FromTable
	IF(@rows = 0) BEGIN
		RAISERROR('FromTable (%s) is empty. Exiting', 10, 1, @FromTable); RETURN
	END ELSE
		PRINT FORMATMESSAGE('FromTable (%s) ok', @FromTable)

	EXECUTE @rows = dbo.table_row_count @ToTable
	IF(@rows > 0) BEGIN
		RAISERROR('ToTable (%s) is not empty. It has %i rows. Exiting', 10, 1, @ToTable, @rows); RETURN
	END ELSE
		PRINT FORMATMESSAGE('ToTable (%s) ok', @ToTable)

	PRINT FORMATMESSAGE('Copying records from %s to %s', @FromTable, @ToTable)

	SET @sql = FORMATMESSAGE('INSERT INTO %s (' + @from_cols_csv + ') SELECT ' + @from_cols_csv + ' FROM %s', @ToTable, @FromTable); 
	
	SET @sql_final = 'SET IDENTITY_INSERT ' + @FromTable + ' OFF; SET IDENTITY_INSERT ' + @ToTable + ' ON' + '; ' +  @sql + '; SET IDENTITY_INSERT ' + @ToTable + ' OFF'

	PRINT FORMATMESSAGE('@@sql_final = %s', @sql_final)

	EXEC sp_executesql @sql_final

	PRINT 'done'

END

GO