SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- Function to check if file exists
/*
Example
IF dbo.FileExists(@FileName) = 1
			BEGIN
       ......
BULK INSERT A0123
		FROM @FileName
WITH
	  (	
		FIRSTROW = 2,
		CODEPAGE = ''ACP'',
		KEEPNULLS ,
		FIELDTERMINATOR = ''\t'',	
  		ROWTERMINATOR = ''\n'',
		MAXERRORS = 100000
       ......
      END 
*/


CREATE FUNCTION [dbo].[FileExists](@path VARCHAR(8000))
RETURNS BIT
AS
BEGIN
     DECLARE @result INT
     EXEC master.dbo.xp_fileexist @path, @result OUTPUT
     RETURN CAST(@result AS BIT)
END;
GO
