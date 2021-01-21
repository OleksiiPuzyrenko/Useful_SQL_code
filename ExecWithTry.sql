SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- the same as EXECUTE , BUT EXECUTE SQL with Try/Catch Error block
/* -- Catch error from BULK INSERT --*/
				-- BULK INSERT errors DON'T stop SP
				-- we need to catch it and generate error to stop SP ,
				-- NOT to do MERGE
				-- and Log it in iteration log
/* ---------------------------*/

Example
-------
.......
  IF dbo.FileExists(@FilePath + @FileName) = 1
			BEGIN

				CREATE TABLE #A016
				(DATAB VARCHAR(10), 
				 DATBI VARCHAR(10),
				 EVRTN VARCHAR(10),
				 EVRTP VARCHAR(10),
				 KAPPL VARCHAR(5), 
				 KSCHL VARCHAR(5) 
				);

				SET @SQL = 'BULK INSERT #A016
		FROM ''' + @FilePath + @FileName + '''
	WITH
	  (	
		FIRSTROW = 2,
		CODEPAGE = ''ACP'',
		KEEPNULLS ,
		FIELDTERMINATOR = ''\t'',	
		ROWTERMINATOR = ''\n'',
		MAXERRORS = 100000
	  );';

                DECLARE @RC INT= 0;
                DECLARE @Err VARCHAR(MAX)= '';
                DECLARE @ErrorMessage NVARCHAR(4000)= '';
                DECLARE @ErrorSeverity INT= 0;
                DECLARE @ErrorState INT= 0;
                --
                EXECUTE @RC = dbo.ExecWithTry 
                        @SQL, 
                        @Err OUTPUT, 
                        @ErrorMessage OUTPUT, 
                        @ErrorSeverity OUTPUT, 
                        @ErrorState OUTPUT;
                --
                IF @RC = 0
                    -- have some error EXIT !
                    BEGIN
                        PRINT @ERR;
                        RAISERROR(@ErrorMessage, -- Message text.  
                        @ErrorSeverity, -- Severity.  
                        @ErrorState -- State.  
                        );
                        PRINT 'ERR - EXIT';
                        RETURN;
                     END;
        -- NO errors - MERGE !                     
				MERGE SAP.A016 AS T
				USING #A016 AS S .......
   
*/
----------------------------
CREATE PROCEDURE [dbo].[ExecWithTry] 
                           @SQL           VARCHAR(MAX), 
                           @Err           VARCHAR(MAX) OUTPUT, 
                           @ErrorMessage  NVARCHAR(4000) OUTPUT, 
                           @ErrorSeverity INT OUTPUT, 
                           @ErrorState    INT OUTPUT
AS
    BEGIN
        BEGIN TRY
            EXEC (@SQL);
            RETURN 1;
        END TRY
        BEGIN CATCH
            
			SET @Err = CONVERT(VARCHAR(30), GETDATE(), 121) + ' - ErrorNumber :' + ISNULL(TRY_CAST(ERROR_NUMBER() AS VARCHAR(10)), '') + ' ErrorSeverity : ' + ISNULL(TRY_CAST(ERROR_SEVERITY() AS VARCHAR(10)), '') + ' ErrorState  : ' + ISNULL(TRY_CAST(ERROR_STATE() AS VARCHAR(10)), '') + ' ErrorProcedure : ' + ISNULL(ERROR_PROCEDURE(), '') + ' ErrorLine : ' + ISNULL(TRY_CAST(ERROR_LINE() AS VARCHAR(10)), '') + ' ErrorMessage : ' + ISNULL(ERROR_MESSAGE(), '');
            --PRINT @Err;

            SELECT @ErrorMessage = ERROR_MESSAGE(), 
                   @ErrorSeverity = ERROR_SEVERITY(), 
                   @ErrorState = ERROR_STATE();
            RETURN 0;
        END CATCH;
    END;
