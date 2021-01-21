
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		A.Puzyrenko
-- Create date: 16.02.2017
-- Description:	ChangelogTrigger
-- =============================================
ALTER TRIGGER [dbo].[ChangeLogRoles]
ON [dbo].[Roles]
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @Action AS CHAR(1);

    SET @Action = 'I'; -- Set Action to Insert by default.
    IF EXISTS (SELECT TOP (1) 1 FROM DELETED)
    BEGIN
        SET @Action = CASE
                           WHEN EXISTS (SELECT TOP (1) 1 FROM INSERTED) THEN 'U' -- Set Action to Updated.
                           ELSE 'D' -- Set Action to Deleted.       
                      END;
    END;
    ELSE IF NOT EXISTS (SELECT TOP (1) 1 FROM INSERTED)
        RETURN; -- Nothing updated or inserted.

    DECLARE @ChangeDate DATETIME = GETDATE();
    DECLARE @UserID VARCHAR(250) = dbo.GetUserID();
    DECLARE @HostName VARCHAR(250) = HOST_NAME();

    IF @Action = 'I'
    OR @Action = 'U'
        INSERT INTO dbo.Roles_H (RoleID,
                                 RoleName,
                                 RoleDescription,
                                 ChangedDate,
                                 UserID,
                                 HostName,
                                 ChangeAction,
                                 ActionRowNumb)
        SELECT RoleID,
               RoleName,
               RoleDescription,
               @ChangeDate,
               @UserID,
               @HostName,
               @Action,
               CASE
                    WHEN @Action = 'U' THEN 2
                    ELSE 1 END
          FROM Inserted;

    IF @Action = 'U'
    OR @Action = 'D'
        INSERT INTO dbo.Roles_H (RoleID,
                                 RoleName,
                                 RoleDescription,
                                 ChangedDate,
                                 UserID,
                                 HostName,
                                 ChangeAction,
                                 ActionRowNumb)
        SELECT RoleID,
               RoleName,
               RoleDescription,
               @ChangeDate,
               @UserID,
               @HostName,
               @Action,
               1
          FROM Deleted;

END;
