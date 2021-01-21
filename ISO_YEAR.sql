SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[ISO_YEAR] (@Date DATETIME)
RETURNS INT
AS
BEGIN
  DECLARE @ISOyear INT = DATEPART(YEAR, @Date);

  -- WHEN January 1-3 may belong to the previous year
  IF (DATEPART(MONTH, @DATE) = 1 AND DATEPART(ISO_WEEK, @DATE) > 50)
    SET @ISOyear = @ISOyear - 1;

  -- WHEN December 29-31 may belong to the next year
  IF (DATEPART(MONTH, @DATE) = 12 AND DATEPART(ISO_WEEK, @DATE) < 45)
    SET @ISOyear = @ISOyear + 1;

  RETURN @ISOYear;

END
GO
