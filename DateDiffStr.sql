/****** Object:  UserDefinedFunction [dbo].[DateDiffStr]    Script Date: 20/01/2021 20:32:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DateDiffStr]
-- Returns date diff as string as D d HH:MM:SS 
-- 
(
    @StartDate DATETIME,
    @EndDate DATETIME
)
RETURNS VARCHAR(20)
AS
BEGIN

    DECLARE @ResultVar VARCHAR(20) = '-';

    IF @StartDate IS NULL
        SET @StartDate = GETDATE();

    IF @EndDate IS NULL
        SET @EndDate = GETDATE();

    IF @StartDate <= @EndDate
    BEGIN
        DECLARE @Sec INT;
        DECLARE @H INT;
        DECLARE @M INT;
        DECLARE @D INT = 0;

        SET @Sec = DATEDIFF(s, @StartDate, @EndDate);

        SET @H = FLOOR(@Sec / 3600);

        SET @Sec = @Sec - @H * 3600;

        SET @M = FLOOR(@Sec / 60);

        SET @Sec = @Sec - @M * 60;

        IF @H >= 24
        BEGIN
            SET @D = FLOOR(@H / 24);
            SET @H = @H - @D * 24;
        END;

        SET @ResultVar
            = IIF(@D > 0, TRY_CAST(@D AS VARCHAR) + ' d ', '') + TRY_CAST(@H AS VARCHAR) + ':'
              + RIGHT('00' + TRY_CAST(@M AS VARCHAR), 2) + ':' + RIGHT('00' + TRY_CAST(@Sec AS VARCHAR), 2);

    END;

    RETURN @ResultVar;
END;
