SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetUserID]()
RETURNS VARCHAR(250)
AS
     BEGIN
         DECLARE @UserID VARCHAR(250)= NULL;
         DECLARE @UserID_Local VARCHAR(250)= NULL;
         SELECT TOP (1) @UserID = [UserID]
         FROM [dbo].[UsersSessions]
         WHERE ProcessID = @@SPID
               AND HostName = HOST_NAME()
               AND [SessionEnd] IS NULL
               AND IsBad = 0
         ORDER BY SessionID;
         --
         IF @UserID IS NULL
             BEGIN
                 SET @UserID_Local = SYSTEM_USER;
                 SET @UserID = SYSTEM_USER + '-' + HOST_NAME();
                 IF CHARINDEX('\', @UserID_local) <> 0
                     BEGIN
                         SET @UserID_Local = SUBSTRING(@UserID_Local, CHARINDEX('\', @UserID_Local) + 1, LEN(@UserID_Local));
                         IF EXISTS
                         (
                             SELECT TOP 1 1
                             FROM dbo.Users
                             WHERE UserID = @UserID_Local
                         )
                             SET @UserID = @UserID_Local;
                             ELSE
                             SET @UserID = SYSTEM_USER + '-' + HOST_NAME();
                 END;
         END;
         --	 PRINT @UserID_Local
         --	 PRINT @UserID
         RETURN @UserID;
     END;
GO
