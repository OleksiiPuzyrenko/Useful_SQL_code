-- SP UserLogIn
-- Creates new session for User
-- Returns Permission Matrix for user


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UserLogIn]
    @WindowsUserName VARCHAR(50),
    @MainSessionID INT = NULL
AS
BEGIN

    DECLARE @WindowsUserID VARCHAR(50) = '';
    DECLARE @UserID_Local VARCHAR(150) = NULL;

    DECLARE @SessionID INT = -1;
    DECLARE @Description VARCHAR(250) = '';
    DECLARE @Language CHAR(1) = NULL;
    DECLARE @LanguageDB CHAR(1) = NULL;
    SET @LanguageDB = dbo.GetDBDefaultLang();

    DECLARE @UserName_Local VARCHAR(50) = NULL;
    -----------------
    -- Cut Domain name 
    SET @WindowsUserID
        = UPPER(SUBSTRING(@WindowsUserName, CHARINDEX('\', @WindowsUserName) + 1, LEN(@WindowsUserName)));
    PRINT @WindowsUserID;

    IF LEN(@WindowsUserID) > 0
    BEGIN
        SELECT @UserID_Local = UserID,
               @UserIsLocked = IsLocked,
               @Language = [LanguageID]
        FROM dbo.Users
        WHERE UserID = @WindowsUserID;

        IF @UserID_Local IS NULL
        -- Add new user with min rights
        BEGIN

            SELECT @UserName_Local = LTRIM(RTRIM(NAME_TEXT))
            FROM [SAP].[V_USR_NAME]
            WHERE BNAME = @WindowsUserID;

            IF @UserName_Local IS NULL
                SET @UserName_Local = @WindowsUserID;

            SET @Language = @LanguageDB;

            EXEC dbo.UpdateUsersData @UserID = @WindowsUserID,
                                     @UserName = @UserName_Local,
                                     @LanguageID = @Language;

            EXEC dbo.UpdateUserPermissionByCode @UserID = @WindowsUserID,
                                                @PermissionCode = 'IsObsList',
                                                @PermissionTypeID = 1; -- Default for all


            SET @UserID_Local = @WindowsUserID;
        END;

        IF @UserIsLocked = 0
        BEGIN
            EXEC [dbo].[CreateUserSession] @UserID = @UserID_Local,
                                           @SessionID = @SessionID OUTPUT,
                                           @MainSessionID = @MainSessionID;
            PRINT @SessionID;
        END;
        ELSE
            SET @Description = 'User is Locked / Gebruiker is gesloten';
    END;
    ELSE
    BEGIN
        SET @UserID_Local = @WindowsUserName;
        SET @Description = 'Wrong Username / Verkeerde gebruikersnaam';
        PRINT 'Wrong UserName';
    END;
    -- Return result 

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

END;
