/****** Object:  StoredProcedure [dbo].[CreateUserSession]    Script Date: 21/01/2021 14:59:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreateUserSession]
    @UserID VARCHAR(50) = NULL,
    @SessionID INT OUTPUT,
    @MainSessionID INT = NULL
AS
BEGIN
    /*Create  SESSIONS for connected user*/

    --DECLARE @UserID VARCHAR(50) = 'Test'

    SET NOCOUNT ON;

    -----
    DECLARE @UserID_Local VARCHAR(150) = NULL;

    DECLARE @MainSessionIDLocal INT = NULL;

    IF @MainSessionID IS NOT NULL
        SELECT @MainSessionIDLocal = SessionID
          FROM dbo.UsersSessions
         WHERE SessionID = @MainSessionID;

    -- Initialize SessionID
    SET @SessionID = -1;

    -- Check if UserID exists in Users table 
    -- If NOT exists use SystemName

    SELECT @UserID_Local = UserID
      FROM dbo.Users
     WHERE UserID = @UserID;

    IF (@UserID_Local IS NULL)
        SET @UserID_Local = SYSTEM_USER;
    -----------------
    -- Cut Domain from user name 
    SET @UserID_Local = SUBSTRING(@UserID_Local, CHARINDEX('\', @UserID_Local) + 1, LEN(@UserID_Local));

    -- Check if exists open Session for @@SPID and computer 
    SELECT @SessionID = SessionID
      FROM dbo.UsersSessions
     WHERE ProcessID = @@SPID
       AND SessionEnd IS NULL
       AND HostName  = HOST_NAME()
       AND UserID    = @UserID_Local;


    DECLARE @AppName NVARCHAR(128);
    SELECT @AppName = LTRIM(RTRIM(program_name)) + N', ' + LTRIM(RTRIM(net_library))
      FROM master.dbo.sysprocesses
     WHERE spid = @@SPID;


    IF @SessionID <> -1
    BEGIN
        --SELECT  @SessionID;
        UPDATE dbo.UsersSessions
           SET MainSessionID = @MainSessionIDLocal,
               AppName = @AppName,
               SysUser = SYSTEM_USER
         WHERE SessionID = @SessionID;
        RETURN (1);
    END;

    INSERT INTO dbo.UsersSessions (UserID,
                                       SysUser,
                                       HostName,
                                       SessionStart,
                                       SessionEnd,
                                       ProcessID,
                                       AppName,
                                       IsBad,
                                       MainSessionID)
    VALUES (@UserID_Local, SYSTEM_USER, HOST_NAME(), GETDATE(), NULL, @@SPID, @AppName, 0, @MainSessionIDLocal);

    SELECT @SessionID = SessionID
      FROM dbo.UsersSessions
     WHERE SessionID = SCOPE_IDENTITY();


    -- Check for Bad sessions ( was not finished properly )
    --PRINT 'CheckBadSessions';
    -- PRINT @@SPID

    EXEC dbo.CheckBadSessions;

    --SELECT  @SessionID;
    RETURN (0);

END;
GO
