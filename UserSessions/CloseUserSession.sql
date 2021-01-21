/****** Object:  StoredProcedure [dbo].[CloseUserSession]    Script Date: 21/01/2021 14:00:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---
CREATE PROCEDURE [dbo].[CloseUserSession] @SessionID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.UsersSessions
       SET SessionEnd = GETDATE(),
           IsBad = 0
     WHERE SessionID     = @SessionID
        OR MainSessionID = @SessionID;

END;
GO
