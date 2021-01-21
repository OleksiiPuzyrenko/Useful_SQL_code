

/****** Object:  StoredProcedure [dbo].[CrossTab_PIVOT]    Script Date: 21/01/2021 14:51:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---- 
-- Create CROSS Table
----

CREATE PROCEDURE [dbo].[CrossTab_PIVOT]
    @Table AS sysname,                     -- Source table for crosstab
    @OnRows AS NVARCHAR(250),              -- Value for groupping by rows
    @OnRowsAlias AS sysname,               -- Alias for groupped column 
    @OnCols AS NVARCHAR(250),              -- -- Value for groupping by columns ( Pivot column names)
    @OnColsSort AS NVARCHAR(250),          -- Value for Pivot columns Order by
    @OnColsFilter AS NVARCHAR(250) = NULL, -- where clause to filter out Pivot column names
    @AgrCol AS NVARCHAR(250) = NULL,       -- Value for Pivot columns aggregation
    @AgrColName AS NVARCHAR(250) = NULL,   -- name for Pivot columns aggregation
    @AgrColType AS NVARCHAR(250) = NULL,   -- data type for Pivot columns aggregation
    @AgrFunc AS NVARCHAR(100) = 'MAX',     -- Aggregate function
    @UnPivotCol AS NVARCHAR(250) = NULL,   -- Un Pivot Column list from source table
    @RowSort AS NVARCHAR(250)              -- Order by for Pivot table,



AS
BEGIN
    IF @Table IS NULL
        RETURN -1;

    SET NOCOUNT ON;

    DECLARE @sql AS NVARCHAR(MAX),
            @case AS NVARCHAR(4000),
            @caseT AS NVARCHAR(4000);

    SET @case = N'';
    SELECT @sql
        = N'
SELECT @case=@case+quotename( MAX(' + @OnCols + N') )+'', ''' + N' FROM ' + @Table
          + IIF(@OnColsFilter IS NOT NULL, ' where ' + @OnColsFilter, '') + N' GROUP BY ' + @OnColsSort + N' ORDER BY '
          + @OnColsSort;

    --PRINT @SQL
    EXEC sp_executesql @sql, N'@case varchar(1000) out', @case = @case OUT;
    SET @case = LEFT(@case, LEN(@case) - 1);
    --PRINT @case

    IF @AgrColType IS NULL
        SET @caseT = @case;
    ELSE
    BEGIN
        SET @caseT = N'';

        SELECT @caseT = @caseT + N'Try_cast(' + Value + N' AS ' + @AgrColType + N') as ' + Value + N', '
        FROM dbo.Split(@case, ',');

        SET @caseT = LEFT(@caseT, LEN(@caseT) - 1);
    --PRINT @caseT;
    END;

    SELECT @sql
        = N'SELECT ' + @OnRows + N' as ' + @OnRowsAlias + IIF(@UnPivotCol IS NOT NULL, +',' + @UnPivotCol, '') + +N', '
          + @caseT + N' FROM (
SELECT '          + @OnCols + N' y, ' + @OnRows + N' as ' + @OnRowsAlias + N', ' + @AgrCol + N' as '
          + IIF(@AgrColName IS NOT NULL, @AgrColName, @AgrCol) + IIF(@UnPivotCol IS NOT NULL, +',' + @UnPivotCol, '')
          + N' FROM ' + @Table + N') as s
PIVOT
('                + @AgrFunc + N'(' + IIF(@AgrColName IS NOT NULL, @AgrColName, @AgrCol) + N') for y in (' + @case
          + N')) as pv
order by '        + IIF(@RowSort IS NOT NULL, @RowSort, @OnRows);
    PRINT @sql;
    EXECUTE (@sql);
END;



GO


/*
Example

    SELECT U.UserID,
           P.PermissionID,
           ISNULL(UP.PermissionTypeID, 0) PermissionTypeID,
           IIF(ISNULL(UP.PermissionTypeID, 0) > 0, 1, 0) PermissionFlag,
           P.PermissionCode
    INTO #Perm_User_login_Temp_21102020
    FROM dbo.Users U
        CROSS APPLY [dbo].[PermissionsName] P
        LEFT JOIN [dbo].[UsersPermissions] UP
            ON UP.PermissionID = P.PermissionID
               AND U.UserID = UP.UserID
    WHERE U.UserID = @WindowsUserID;

    DECLARE @UnPivotColVal VARCHAR(100)
        = TRY_CAST(@SessionID AS VARCHAR(10)) + ' AS SessionID,' + TRY_CAST(@UserIsLocked AS CHAR(1))
          + ' as  IsLocked,' + '''' + ISNULL(@Language, @LanguageDB) + ''' as  [Language],' + '''' + @Description
          + ''' AS  Description';


    EXEC dbo.CrossTab_PIVOT @Table = '#Perm_User_login_Temp_21102020', -- Source table for crosstab
                            @OnRows = 'UserID',                        -- Value for groupping by rows
                            @OnRowsAlias = '[UserID]',                 -- Alias for groupped column 
                            @OnCols = 'PermissionCode',                -- -- Value for groupping by columns ( Pivot column names)
                            @OnColsSort = 'PermissionID',              -- Value for Pivot columns Order by
                            @OnColsFilter = NULL,                      -- where clause to filter out Pivot column names
                            @AgrCol = 'PermissionTypeID',              -- Value for Pivot columns aggregation
                            @AgrColName = 'PermissionTypeID',          -- name for Pivot columns aggregation
                            @AgrColType = NULL,
                            @AgrFunc = 'MAX',                          -- Aggregate function
                            @UnPivotCol = @UnPivotColVal,              -- Un Pivot Column list from source table
                            @RowSort = 'UserID';

    DROP TABLE #Perm_User_login_Temp_21102020;
    */
