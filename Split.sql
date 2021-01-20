/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 20/01/2021 20:25:51 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Split]    
-- Function creates Table from list of values --
(    
  @List VARCHAR(MAX),    -- list of values to transform 
  @SplitOn VARCHAR(5)    -- item separator
 )      
 RETURNS @RtnValue TABLE     
 (    

  Id INT IDENTITY(1,1),    
  Value VARCHAR(100)  COLLATE DATABASE_DEFAULT NOT NULL  
 )     
 AS      
 BEGIN     
  WHILE (CHARINDEX(@SplitOn,@List)>0)    
  BEGIN    

   INSERT INTO @RtnValue (value)    
   SELECT     
    Value = LTRIM(RTRIM(SUBSTRING(@List,1,CHARINDEX(@SplitOn,@List)-1)))    

   SET @List = SUBSTRING(@List,CHARINDEX(@SplitOn,@List)+LEN(@SplitOn),LEN(@List))    
  END    

  INSERT INTO @RtnValue (Value)    
  SELECT Value = LTRIM(RTRIM(@List))    

  RETURN    
 END
