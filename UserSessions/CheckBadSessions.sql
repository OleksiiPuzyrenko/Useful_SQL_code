/****** Object:  StoredProcedure [dbo].[CheckBadSessions]    Script Date: 21/01/2021 15:01:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* Mark "unclosed" session as bad
Should be only 1 NotBad Session for ProcessID(@@SPID) 
*/

CREATE PROCEDURE [dbo].[CheckBadSessions]
AS
    BEGIN
        SET NOCOUNT ON;
        WITH Sessions_CTE
             AS (SELECT SessionID, 
                        UserID, 
                        SysUser, 
                        HostName, 
                        SessionStart, 
                        SessionEnd, 
                        ProcessID, 
                        AppName, 
                        IsBad, 
                        ROW_NUMBER() OVER(PARTITION BY ProcessID
                        ORDER BY SessionID DESC) RowIndex
                 FROM dbo.UsersSessions
                 WHERE SessionEnd IS NULL
                       AND IsBad = 0)
             UPDATE Sessions_CTE
               SET 
                   IsBad = 1, 
                   SessionEnd = GETDATE()
             WHERE RowIndex > 1;

        -----
        -- Mark 2nd and 3rd seesion as Bad if Main is Bad 
        ----- 
        UPDATE s
          SET 
              IsBad = 1, 
              SessionEnd = GETDATE()
        --SELECT *
        FROM dbo.UsersSessions S
        WHERE EXISTS
        (
            SELECT TOP 1 1
            FROM dbo.UsersSessions MS
            WHERE MS.MainSessionID IS NULL
                  AND MS.isBad = 1
                  AND S.MainSessionID = MS.SessionID
        )
              AND S.IsBad = 0;
    END;
GO

