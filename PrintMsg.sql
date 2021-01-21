/* 
SP to use instead of PRINT
     @Msg  - message to print
     @PrintTimeStamp ( default =0) - if =1 when timestamp is printed
Example :
EXEC dbo.PrintMsg @Msg = 'Test Message' 
Result 
Test Message

EXEC dbo.PrintMsg @Msg = 'Test Message' ,@PrintTimeStamp = 1
Result 
2021-01-21 13:29:06.7106633 - Test Message
 */
 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[PrintMsg]
    @Msg VARCHAR(MAX)='',
    @PrintTimeStamp BIT = 0
AS
BEGIN
    DECLARE @startTime DATETIME2(7) = SYSDATETIME();
    --DECLARE @Msg VARCHAR(MAX) = 'Test' 

    IF @PrintTimeStamp = 1
        SET @Msg = TRY_CAST(@startTime AS VARCHAR(50)) + ' - ' + @Msg;
		
    RAISERROR(@Msg, 0, 1) WITH NOWAIT;
END;
