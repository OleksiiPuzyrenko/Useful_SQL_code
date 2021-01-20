-- SP_AT, SP_RAT, SP_OCCURS, SP_PADC, SP_PADR, SP_PADL, SP_CHRTRAN, SP_STRTRAN, SP_STRFILTER,
-- SP_GETWORDCOUNT, SP_GETWORDNUM, SP_GETALLWORDS, SP_PROPER, SP_RCHARINDEX, SP_ARABTOROMAN, SP_ROMANTOARAB
-- SP_AT()  Returns the beginning numeric position of the nth occurrence of a character expression within
--       another character expression, counting from the leftmost character
-- SP_RAT() Returns the numeric position of the last (rightmost) occurrence of a character string within 
--       another character string
-- SP_OCCURS() Returns the number of times a character expression occurs within another character expression
-- SP_PADL()   Returns a string from an expression, padded with spaces or characters to a specified length on the left side
-- SP_PADR()   Returns a string from an expression, padded with spaces or characters to a specified length on the right side
-- SP_PADC()   Returns a string from an expression, padded with spaces or characters to a specified length on the both sides
-- SP_CHRTRAN()   Replaces each character in a character expression that matches a character in a second character expression
--             with the corresponding character in a third character expression.
-- SP_STRTRAN()   Searches a character expression for occurrences of a second character expression,
--             and then replaces each occurrence with a third character expression.
--             Unlike a built-in function replace, SP_STRTRAN has three additional parameters.
-- SP_STRFILTER() Removes all characters from a string except those specified. 
-- SP_GETWORDCOUNT() Counts the words in a string
-- SP_GETWORDNUM()   Returns a specified word from a string
-- SP_GETALLWORDS()  Inserts the words from a string into the table
-- SP_PROPER() Returns from a character expression a string capitalized as appropriate for proper names
-- SP_RCHARINDEX()  Similar to the Transact-SQL function Charindex, with a Right search
-- SP_ARABTOROMAN() Returns the character Roman numeral equivalent of a specified numeric expression (from 1 to 3999)
-- SP_ROMANTOARAB() Returns the number equivalent of a specified character Roman numeral expression (from I to MMMCMXCIX)
-- Examples:   SP_GETWORDCOUNT, SP_GETWORDNUM
-- declare @nWordcount smallint 
-- exec dbo.SP_GETWORDCOUNT @nWordcount output, 'User-Defined marvellous string Functions Transact-SQL', default
-- exec dbo.SP_GETWORDNUM 'User-Defined marvellous string Functions Transact-SQL', 2, default
-- Examples:  SP_CHRTRAN, SP_STRFILTER
-- declare @nOccurs smallint
-- exec dbo.SP_CHRTRAN 'ABCDEF', 'ACE', 'XYZ'  -- Displays XBYDZF
-- exec dbo.SP_STRFILTER 'ABCDABCDABCD', 'AB'  -- Displays ABABAB
-- Examples:  SP_AT, SP_OCCURS, SP_PROPER
-- exec dbo.SP_AT 'marvellous', 'User-Defined marvellous string Functions Transact-SQL', default
-- exec dbo.SP_OCCURS  'F', 'User-Defined marvellous string Functions Transact-SQL', @nOccurs output
-- exec dbo.SP_PROPER 'User-Defined marvellous string Functions Transact-SQL'
-- SP_PADC, SP_PADR, SP_PADL 
-- exec dbo.SP_PADC ' marvellous string Functions', 60, '+*+'
-- SP_ARABTOROMAN, SP_ROMANTOARAB
-- declare @cResult varchar(75), @nResult  smallint 
-- exec dbo.SP_ARABTOROMAN @cResult output, 3888  --      Displays MMMDCCCLXXXVIII
-- exec dbo.SP_ROMANTOARAB @nResult output, 'CCXXXIV' -- Displays 234
-- For more information about string UDFs Transact-SQL please visit the 
-- http://www.universalthread.com/wconnect/wc.dll?LevelExtreme~2,54,33,27115   or 
-- http://nikiforov.developpez.com/espagnol/  (the Spanish language)
-- http://nikiforov.developpez.com/           (the French  language)
-- http://nikiforov.developpez.com/allemand/  (the German  language)
-- http://nikiforov.developpez.com/italien/   (the Italian language)
-- http://nikiforov.developpez.com/portugais/ (the Portuguese language)
-- http://nikiforov.developpez.com/roumain/   (the Roumanian  language)
-- http://nikiforov.developpez.com/russe/     (the Russian language)
-- http://nikiforov.developpez.com/bulgare/   (the Bulgarian language)
--------------------------------------------------------------------------------------------------------


CREATE procedure SP_COMPARISON_EXACT
@cString1 nvarchar(4000), @cString2 nvarchar(4000), @nResult bit = 0 output
as
      set nocount on
      declare @i smallint,  @nLen  smallint      
      select  @nResult = 0, @nLen = datalength(@cString1)/2 -- for unicode
      if @nLen = datalength(@cString2)/2
         begin
            select  @i = 1, @nResult = 0
            while  @i <= @nLen
               begin
                 if unicode(substring(@cString1, @i, 1)) <>  unicode(substring(@cString2, @i, 1))
                    begin                 
                      select @nResult = 0                
                      break
                    end   
                 else
                    select  @i = @i + 1   
               end
         end
GO


-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
-- Similar to the Transact-SQL function Charindex, but regardless of collation settings,  
-- executes case-sensitive search  
CREATE procedure SP_CHARINDEX_BIN
@expression1 nvarchar(4000), @expression2  nvarchar(4000), @start_location  smallint = 1 output
as
   set nocount on
   declare @i smallint,  @nLen1  smallint,  @nLen2  smallint,  @nResult bit             
   select  @nResult = 0, @nLen1 = datalength(@expression1)/2,  @nLen2 = datalength(@expression2)/2  -- for unicode

   if @start_location <= 0
      select @start_location = 1

    while  @start_location <=  ( @nLen2-@nLen1+1) and @start_location <= 4000
        begin
             select @start_location  = charindex(@expression1, @expression2, @start_location )

              if @start_location > 0
                 begin
                       select  @nResult = 1, @i = 1
                       while  @i <= @nLen1
                            begin
                                 if unicode(substring(@expression1, @i, 1)) <>  unicode(substring(@expression2, @start_location+@i-1, 1))
                                      begin                 
                                          select @nResult = 0                
                                           break
                                       end   
                                  select  @i = @i + 1   
                            end
                       if @nResult = 1 
                            break
                      else
                             select @start_location  =  @start_location + 1     
                 end
             else
                  break
        end

           if @nResult = 0 
              select @start_location  = 0
GO


-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
-- Similar to the Transact-SQL function Charindex, but regardless of collation settings,  
-- executes case-insensitive search  
CREATE procedure SP_CHARINDEX_CI
@expression1 nvarchar(4000), @expression2  nvarchar(4000), @start_location  smallint = 1 output
as
       set nocount on
       select @start_location  =  charindex(lower(@expression1), lower(@expression2), @start_location)
GO

CREATE procedure SP_REPLACE
@cSearched nvarchar(4000) output,  @cExpressionSought nvarchar(4000), @cReplacement nvarchar(4000) = N'',  @nFlags bit = 0
as
      set nocount on
      declare @nWhere smallint, @LencReplacement smallint,  @LenExpressionSought smallint
      select    @nWhere = 1, @LencReplacement  = datalength(@cReplacement)/2 ,  -- for unicode
                    @LenExpressionSought  = datalength(@cExpressionSought)/2 -- for unicode

      while  @nWhere > 0
            begin
                if @nFlags  = 0
                    exec dbo.SP_CHARINDEX_BIN @cExpressionSought, @cSearched, @nWhere output 
                else
                   exec dbo.SP_CHARINDEX_CI @cExpressionSought, @cSearched, @nWhere output       
                 if @nWhere > 0
                         select @cSearched = stuff(@cSearched, @nWhere, @LenExpressionSought, @cReplacement), @nWhere = @nWhere + @LencReplacement
            end
GO


-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
-- SP_AT() Stored Procedures 
-- Returns the beginning numeric position of the first occurrence of a character expression within another character expression, counting from the leftmost character.
-- (including  overlaps)
-- SP_AT(@cSearchExpression, @cExpressionSearched [, @nOccurrence]) Return Values smallint 
-- Parameters
-- @cSearchExpression nvarchar(4000) Specifies the character expression that SP_AT( ) searches for in @cExpressionSearched. 
-- @cExpressionSearched nvarchar(4000) Specifies the character expression @cSearchExpression searches for. 
-- @nOccurrence smallint Specifies which occurrence (first, second, third, and so on) of @cSearchExpression is searched for in @cExpressionSearched. By default, SP_AT() searches for the first occurrence of @cSearchExpression (@nOccurrence = 1). Including @nOccurrence lets you search for additional occurrences of @cSearchExpression in @cExpressionSearched. SP_AT( ) returns 0 if @nOccurrence is greater than the number of times @cSearchExpression occurs in @cExpressionSearched. 
-- Remarks
-- SP_AT() searches the second character expression for the first occurrence of the first character expression. It then returns an integer indicating the position of the first character in the character expression found. If the character expression is not found, SP_AT() returns 0. The search performed by SP_AT() is case-sensitive.
-- SP_AT is nearly similar to a function Oracle PL/SQL INSTR
-- Example
-- declare @gcString nvarchar(4000), @gcFindString nvarchar(4000), @nResult  smallint 
-- select @gcString = 'Now is the time for all good men', @gcFindString = 'is the', @nResult = 1
-- exec dbo.SP_AT @gcFindString, @gcString, @nResult output  -- Displays 5
-- select @gcFindString = 'IS', @nResult = 1
-- exec dbo.SP_AT @gcFindString, @gcString, @nResult output  -- Displays 0, case-sensitive
-- select @gcString = 'goood men', @gcFindString = 'oo', @nResult = 1
-- exec dbo.SP_AT @gcFindString, @gcString, @nResult output   -- Displays 2
-- select @nResult = 2
-- exec dbo.SP_AT @gcFindString, @gcString, @nResult output   -- Displays 3, including  overlaps
-- See Also SP_RAT(), SP_ATC(), SP_AT2()  Stored Procedures 
-- procedure the  functionality of which correspond  to the  Visual FoxPro function  
CREATE procedure SP_AT  
@cSearchExpression nvarchar(4000), @cExpressionSearched  nvarchar(4000), @nOccurrence  smallint = 1 output
as
      set nocount on
      if @nOccurrence > 0
         begin
            declare @i smallint,  @StartingPosition  smallint
            select  @i = 0, @StartingPosition  = -1
            while  @StartingPosition <> 0 and @nOccurrence > @i
              begin
               select  @i = @i + 1, @StartingPosition  = @StartingPosition+1
               exec dbo.SP_CHARINDEX_BIN @cSearchExpression, @cExpressionSearched, @StartingPosition output
             end
         end
      else
         set @StartingPosition =  NULL

     select @nOccurrence  = @StartingPosition
     
   -- select @nOccurrence  
GO

-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
-- Similar to the Transact-SQL function Charindex, with a Right search
-- Example
-- declare @gcString nvarchar(4000), @nResult smallint
-- select @gcString = 'Now is the time for all good men', @nResult = 1
-- exec dbo.SP_CHARINDEX_CI  'IS THE', @gcString,  @nResult output  --  Displays 5
-- select @nResult = 1
-- exec dbo.SP_CHARINDEX_BIN 'is the', @gcString, @nResult output  --  Displays 5
-- select @nResult = 1
-- exec dbo.SP_RCHARINDEX    'me', @gcString, @nResult output  --  Displays 30
CREATE procedure SP_RCHARINDEX
@expression1 nvarchar(4000), @expression2  nvarchar(4000), @start_location  smallint = 1  output
as
     set nocount on
     declare @StartingPosition  smallint
     select  @StartingPosition = @start_location, @expression1 = reverse(@expression1), @expression2 = reverse(@expression2)
     exec dbo.SP_CHARINDEX_BIN @expression1, @expression2, @StartingPosition output
     select @start_location =  case 
               when  @StartingPosition > 0
               then  2 - @StartingPosition + datalength(@expression2)/2 - datalength(@expression1)/2   -- for unicode
            else 0 
            end

    -- select @start_location
GO


-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com 
-- SP_RAT( ) Stored Procedure
-- Returns the numeric position of the last (rightmost) occurrence of a character string within another character string.
-- (including  overlaps)
-- SP_RAT(@cSearchExpression, @cExpressionSearched [, @nOccurrence])
-- Return Values smallint 
-- Parameters
-- @cSearchExpression nvarchar(4000) Specifies the character expression that SP_RAT( ) looks for in @cExpressionSearched. 
-- @cExpressionSearched nvarchar(4000) Specifies the character expression that SP_RAT() searches. 
-- @nOccurrence smallint Specifies which occurrence, starting from the right and moving left, of @cSearchExpression SP_RAT() searches for in @cExpressionSearched. By default, SP_RAT() searches for the last occurrence of @cSearchExpression (@nOccurrence = 1). If @nOccurrence is 2, SP_RAT() searches for the next to last occurrence, and so on. 
-- Remarks
-- SP_RAT(), the reverse of the SP_AT() function, searches the character expression in @cExpressionSearched starting from the right and moving left, looking for the last occurrence of the string specified in @cSearchExpression.
-- SP_RAT() returns an integer indicating the position of the first character in @cSearchExpression in @cExpressionSearched. SP_RAT() returns 0 if @cSearchExpression is not found in @cExpressionSearched, or if @nOccurrence is greater than the number of times @cSearchExpression occurs in @cExpressionSearched.
-- The search performed by SP_RAT() is case-sensitive.
-- Example
-- declare @gcString nvarchar(4000), @gcFindString nvarchar(4000), @nResult  smallint 
-- select @gcString = 'abracadabra', @gcFindString = 'a' , @nResult = 1
-- exec dbo.SP_RAT @gcFindString , @gcString, @nResult output --   Displays 11
-- select @nResult = 3
-- exec dbo.SP_RAT @gcFindString , @gcString, @nResult output       --  Displays 6
-- select @gcString = 'goood men', @gcFindString = 'oo', @nResult = 1
-- exec dbo.SP_RAT @gcFindString, @gcString, @nResult output   -- --  Displays 3
-- select @nResult = 2
-- exec dbo.SP_RAT @gcFindString, @gcString, @nResult output   --  Displays 2, including  overlaps
-- See Also SP_AT()  Stored Procedure 
-- procedure the  functionality of which correspond  to the  Visual FoxPro function     
CREATE procedure SP_RAT
@cSearchExpression nvarchar(4000), @cExpressionSearched  nvarchar(4000), @nOccurrence  smallint = 1 output
as
      set nocount on
      if @nOccurrence > 0
         begin
            declare @i smallint, @length smallint, @StartingPosition  smallint
            select  @length  = datalength(@cExpressionSearched)/2 -- for unicode
            select  @cSearchExpression = reverse(@cSearchExpression), @cExpressionSearched  = reverse(@cExpressionSearched)
            select  @i = 0, @StartingPosition  = -1 

            while @StartingPosition <> 0 and @nOccurrence > @i
              begin
                select  @i = @i + 1, @StartingPosition  = @StartingPosition+1
                exec dbo.SP_CHARINDEX_BIN @cSearchExpression, @cExpressionSearched, @StartingPosition output
              end
                              
           if @StartingPosition <> 0
               select @StartingPosition = 2 - @StartingPosition +  @length - datalength(@cSearchExpression)/2 -- for unicode
         end
      else
         set @StartingPosition =  NULL

     select @nOccurrence  = @StartingPosition

  -- select @nOccurrence  
GO

-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
-- SP_AT2() Stored Procedure 
-- Returns the beginning numeric position of the first occurrence of a character expression within another character expression, counting from the leftmost character.
-- (excluding  overlaps)
-- SP_AT2(@cSearchExpression, @cExpressionSearched [, @nOccurrence]) Return Values smallint 
-- Parameters
-- @cSearchExpression nvarchar(4000) Specifies the character expression that SP_AT2( ) searches for in @cExpressionSearched. 
-- @cExpressionSearched nvarchar(4000) Specifies the character expression @cSearchExpression searches for. 
-- @nOccurrence smallint Specifies which occurrence (first, second, third, and so on) of @cSearchExpression is searched for in @cExpressionSearched. By default, SP_AT2() searches for the first occurrence of @cSearchExpression (@nOccurrence = 1). Including @nOccurrence lets you search for additional occurrences of @cSearchExpression in @cExpressionSearched. SP_AT2( ) returns 0 if @nOccurrence is greater than the number of times @cSearchExpression occurs in @cExpressionSearched. 
-- Remarks
-- SP_AT2() searches the second character expression for the first occurrence of the first character expression. It then returns an integer indicating the position of the first character in the character expression found. If the character expression is not found, SP_AT2() returns 0. The search performed by SP_AT2() is case-sensitive.
-- SP_AT2 is nearly similar to a function Oracle PL/SQL INSTR
-- Example
-- declare @gcString nvarchar(4000), @gcFindString nvarchar(4000), @nResult  smallint 
-- select @gcString = 'Now is the time for all good men', @gcFindString = 'is the', @nResult = 1
-- exec dbo.SP_AT2 @gcFindString, @gcString, @nResult output   --  Displays 5
-- select @gcFindString = 'IS', @nResult = 1
-- exec dbo.SP_AT2 @gcFindString, @gcString, @nResult output   --  Displays 0, case-sensitive 
-- select @gcString = 'goood men', @gcFindString = 'oo', @nResult = 1
-- exec dbo.SP_AT2 @gcFindString, @gcString, @nResult output   --  Displays 2
-- select @nResult = 2
-- exec dbo.SP_AT2 @gcFindString, @gcString, @nResult output   --  Displays 0, excluding  overlaps
-- See Also SP_AT(), SP_ATC(), SP_ATC2()  Stored Procedures 
CREATE procedure SP_AT2
@cSearchExpression nvarchar(4000), @cExpressionSearched  nvarchar(4000), @nOccurrence  smallint = 1 output
as
      set nocount on
      declare  @LencSearchExpression smallint
      select    @LencSearchExpression  = datalength(@cSearchExpression)/2 -- for unicode

      if @nOccurrence > 0
         begin
            declare @i smallint,  @StartingPosition  smallint
            select  @i = 0, @StartingPosition  = -1 - @LencSearchExpression
            while  @StartingPosition <> 0 and @nOccurrence > @i
              begin
                select  @i = @i + 1, @StartingPosition = @StartingPosition + @LencSearchExpression
                exec dbo.SP_CHARINDEX_BIN @cSearchExpression, @cExpressionSearched, @StartingPosition output
             end
         end
      else
         set @StartingPosition =  NULL
    select @nOccurrence  = @StartingPosition
 -- select @nOccurrence  
GO

-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
-- SP_ATC() Stored Procedure 
-- Returns the beginning numeric position of the first occurrence of a character expression within another character expression, counting from the leftmost character.
-- The search performed by SP_ATC() is case-insensitive (including  overlaps). 
-- SP_ATC(@cSearchExpression, @cExpressionSearched [, @nOccurrence]) Return Values smallint 
-- Parameters
-- @cSearchExpression nvarchar(4000) Specifies the character expression that SP_ATC( ) searches for in @cExpressionSearched. 
-- @cExpressionSearched nvarchar(4000) Specifies the character expression @cSearchExpression searches for. 
-- @nOccurrence smallint Specifies which occurrence (first, second, third, and so on) of @cSearchExpression is searched for in @cExpressionSearched. By default, SP_ATC() searches for the first occurrence of @cSearchExpression (@nOccurrence = 1). Including @nOccurrence lets you search for additional occurrences of @cSearchExpression in @cExpressionSearched.
-- SP_ATC( ) returns 0 if @nOccurrence is greater than the number of times @cSearchExpression occurs in @cExpressionSearched. 
-- Remarks
-- SP_ATC() searches the second character expression for the first occurrence of the first character expression,
-- without concern for the case (upper or lower) of the characters in either expression. Use SP_AT( ) to perform a case-sensitive search.
-- It then returns an integer indicating the position of the first character in the character expression found. If the character expression is not found, SP_ATC() returns 0. 
-- SP_ATC is nearly similar to a function Oracle PL/SQL INSTR
-- Example
-- declare @gcString nvarchar(4000), @gcFindString nvarchar(4000), @nResult  smallint 
-- select @gcString = 'Now is the time for all good men', @gcFindString = 'is the', @nResult = 1
-- exec dbo.SP_ATC @gcFindString, @gcString, @nResult output   --  Displays 5
-- select @gcFindString = 'IS', @nResult = 1
-- exec dbo.SP_ATC @gcFindString, @gcString, @nResult output   --  Displays 5, case-insensitive
-- See Also SP_AT()  Stored Procedure 
-- procedure the  functionality of which correspond  to the  Visual FoxPro function  
CREATE procedure SP_ATC
@cSearchExpression nvarchar(4000), @cExpressionSearched  nvarchar(4000), @nOccurrence  smallint = 1 output
as
      set nocount on
      if @nOccurrence > 0
         begin
            declare @i smallint,  @StartingPosition  smallint
            select  @i = 0, @StartingPosition  = -1
            select  @cSearchExpression = lower(@cSearchExpression), @cExpressionSearched  = lower(@cExpressionSearched)
            while  @StartingPosition <> 0 and @nOccurrence > @i
               select  @i = @i + 1, @StartingPosition  = charindex(@cSearchExpression, @cExpressionSearched,  @StartingPosition+1 )
         end
      else
         set @StartingPosition =  NULL

     select @nOccurrence  = @StartingPosition
     
   -- select @nOccurrence  
GO

-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com 
-- SP_RATC( ) Stored Procedure
-- Returns the numeric position of the last (rightmost) occurrence of a character string within another character string.
-- The search performed by SP_RATC() is case-insensitive (including  overlaps). 
-- SP_RATC(@cSearchExpression, @cExpressionSearched [, @nOccurrence])
-- Return Values smallint 
-- Parameters
-- @cSearchExpression nvarchar(4000) Specifies the character expression that SP_RATC( ) looks for in @cExpressionSearched. 
-- @cExpressionSearched nvarchar(4000) Specifies the character expression that SP_RATC() searches. 
-- @nOccurrence smallint Specifies which occurrence, starting from the right and moving left, of @cSearchExpression SP_RATC() searches for in @cExpressionSearched. By default, SP_RATC() searches for the last occurrence of @cSearchExpression (@nOccurrence = 1). If @nOccurrence is 2, SP_RATC() searches for the next to last occurrence, and so on. 
-- Remarks
-- SP_RATC(), the reverse of the SP_ATC() function, searches the character expression in @cExpressionSearched starting from the right and moving left, looking for the last occurrence of the string specified in @cSearchExpression.
-- SP_RATC() returns an integer indicating the position of the first character in @cSearchExpression in @cExpressionSearched. SP_RATC() returns 0 if @cSearchExpression is not found in @cExpressionSearched, or if @nOccurrence is greater than the number of times @cSearchExpression occurs in @cExpressionSearched.
-- Example
-- declare @gcString nvarchar(4000), @gcFindString nvarchar(4000), @nResult  smallint 
-- select @gcString = 'abracadabra', @gcFindString = 'A', @nResult = 1
-- exec dbo.SP_RATC @gcFindString , @gcString, @nResult output  --  Displays 11
-- select @nResult = 3
-- exec dbo.SP_RATC @gcFindString , @gcString, @nResult output   --  Displays 6
-- See Also SP_ATC()  Stored Procedure 
-- procedure the functionality of which correspond  to the  Visual FoxPro function     
CREATE procedure SP_RATC
@cSearchExpression nvarchar(4000), @cExpressionSearched  nvarchar(4000), @nOccurrence  smallint = 1 output 
as
      set nocount on
      if @nOccurrence > 0
         begin
            declare @i smallint, @length smallint, @StartingPosition  smallint
            select  @length  = datalength(@cExpressionSearched)/2 -- for unicode
            select  @cSearchExpression = lower(reverse(@cSearchExpression)), @cExpressionSearched  = lower(reverse(@cExpressionSearched))
            select  @i = 0, @StartingPosition  = -1 

            while @StartingPosition <> 0 and @nOccurrence > @i
               select  @i = @i + 1, @StartingPosition  = charindex(@cSearchExpression, @cExpressionSearched, @StartingPosition + 1)
           if @StartingPosition <> 0
               select @StartingPosition = 2 - @StartingPosition +  @length - datalength(@cSearchExpression)/2 -- for unicode
         end
      else
         set @StartingPosition =  NULL

     select @nOccurrence  = @StartingPosition

  -- select @nOccurrence 
GO

-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
-- SP_ATC2() Stored Procedure 
-- Returns the beginning numeric position of the first occurrence of a character expression within another character expression, counting from the leftmost character.
-- The search performed by SP_ATC2() is case-insensitive (excluding  overlaps).
-- SP_ATC2(@cSearchExpression, @cExpressionSearched [, @nOccurrence]) Return Values smallint 
-- Parameters
-- @cSearchExpression nvarchar(4000) Specifies the character expression that SP_ATC2( ) searches for in @cExpressionSearched. 
-- @cExpressionSearched nvarchar(4000) Specifies the character expression @cSearchExpression searches for. 
-- @nOccurrence smallint Specifies which occurrence (first, second, third, and so on) of @cSearchExpression is searched for in @cExpressionSearched. By default, SP_ATC2() searches for the first occurrence of @cSearchExpression (@nOccurrence = 1). Including @nOccurrence lets you search for additional occurrences of @cSearchExpression in @cExpressionSearched.
-- SP_ATC2() returns 0 if @nOccurrence is greater than the number of times @cSearchExpression occurs in @cExpressionSearched. 
-- Remarks
-- SP_ATC2() searches the second character expression for the first occurrence of the first character expression. It then returns an integer indicating the position of the first character in the character expression found. If the character expression is not found, SP_ATC2() returns 0. 
-- SP_ATC2 is nearly similar to a function Oracle PL/SQL INSTR
-- Example
-- declare @gcString nvarchar(4000), @gcFindString nvarchar(4000), @nResult  smallint 
-- select @gcString = 'Now is the time for all good men', @gcFindString = 'is the', @nResult = 1
-- exec dbo.SP_ATC2 @gcFindString, @gcString, @nResult output   --  Displays 5
-- select @gcFindString = 'IS', @nResult = 1
-- exec dbo.SP_ATC2 @gcFindString, @gcString, @nResult output   --  Displays 5, case-insensitive
-- select @gcString = 'goood men', @gcFindString = 'oo', @nResult = 1
-- exec dbo.SP_ATC2 @gcFindString, @gcString, @nResult output   --  Displays 2
-- select @nResult = 2
-- exec dbo.SP_ATC2 @gcFindString, @gcString, @nResult output  --  Displays 0, excluding  overlaps
-- See Also SP_AT(), SP_AT2(), SP_ATC2()  Stored Procedures 
CREATE procedure SP_ATC2
@cSearchExpression nvarchar(4000), @cExpressionSearched  nvarchar(4000), @nOccurrence  smallint = 1 output 
as
      set nocount on
      declare  @LencSearchExpression smallint
      select    @LencSearchExpression  = datalength(@cSearchExpression)/2 -- for unicode
      if @nOccurrence > 0
         begin
            declare @i smallint,  @StartingPosition  smallint
            select  @i = 0, @StartingPosition  = -1 - @LencSearchExpression
            select  @cSearchExpression = lower(@cSearchExpression), @cExpressionSearched  = lower(@cExpressionSearched)            
            while  @StartingPosition <> 0 and @nOccurrence > @i
               select  @i = @i + 1, @StartingPosition  = charindex(@cSearchExpression, @cExpressionSearched,  @StartingPosition + @LencSearchExpression)
         end
      else
         set @StartingPosition =  NULL

    select @nOccurrence  = @StartingPosition
    
   -- select @nOccurrence
GO

 -- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
 -- SP_OCCURS() Stored Procedure
 -- Returns the number of times a character expression occurs within another character expression (including  overlaps).
 -- SP_OCCURS is slowly than SP_OCCURS2.
 -- SP_OCCURS(@cSearchExpression, @cExpressionSearched)
 -- Return Values smallint 
 -- Parameters
 -- @cSearchExpression nvarchar(4000) Specifies a character expression that SP_OCCURS() searches for within @cExpressionSearched. 
 -- @cExpressionSearched nvarchar(4000) Specifies the character expression SP_OCCURS() searches for @cSearchExpression. 
 -- Remarks
 -- SP_OCCURS() returns 0 (zero) if @cSearchExpression is not found within @cExpressionSearched.
 --  Example
 --  declare @gcString nvarchar(4000), @nOccurs smallint 
 --  select  @gcString = 'abracadabra'
 --  exec dbo.SP_OCCURS  'a', @gcString, @nOccurs output   --  Displays 5
 --  exec dbo.SP_OCCURS  'b', @gcString, @nOccurs output   --  Displays 2
 --  exec dbo.SP_OCCURS  'c', @gcString, @nOccurs output   --  Displays 1
 --  exec dbo.SP_OCCURS  'e', @gcString, @nOccurs output   --  Displays 0
 --  Including  overlaps !!!
 --  exec dbo.SP_OCCURS  'ABCA', 'ABCABCABCA', @nOccurs output --  Displays 3
 -- 1 occurrence of substring 'ABCA  .. BCABCA' 
 -- 2 occurrence of substring 'ABC...ABCA...BCA' 
 -- 3 occurrence of substring 'ABCABC...ABCA' 
 -- See Also SP_AT(), SP_RAT(), SP_OCCURS2(), SP_AT2(), SP_ATC(), SP_ATC2()    
 -- procedure the functionality of which correspond to the  Visual FoxPro function  
 -- (but function OCCURS of Visual FoxPro counts the 'occurs' excluding  overlaps !)
CREATE procedure SP_OCCURS
@cSearchExpression nvarchar(4000), @cExpressionSearched nvarchar(4000), @tnOutcome smallint output
as
     set nocount on
     declare @start_location smallint
     select  @start_location = -1,   @tnOutcome = -1
     while @start_location <> 0
       begin
          select  @tnOutcome = @tnOutcome + 1, @start_location  = @start_location+1
          exec dbo.SP_CHARINDEX_BIN @cSearchExpression, @cExpressionSearched, @start_location output
       end
   select @tnOutcome      
GO


 -- SP_OCCURS2() Stored Procedure
 -- Returns the number of times a character expression occurs  within another character expression (excluding  overlaps).
 -- SP_OCCURS2 is faster than SP_OCCURS.
 -- SP_OCCURS2(@cSearchExpression, @cExpressionSearched)
 -- Return Values smallint 
 -- Parameters
 -- @cSearchExpression nvarchar(4000) Specifies a character expression that SP_OCCURS2() searches for within @cExpressionSearched. 
 -- @cExpressionSearched nvarchar(4000) Specifies the character expression SP_OCCURS2() searches for @cSearchExpression. 
 -- Remarks
 -- SP_OCCURS2() returns 0 (zero) if @cSearchExpression is not found within @cExpressionSearched.
 -- Example
 --  declare @gcString nvarchar(4000), @nOccurs smallint 
 --  select  @gcString = 'abracadabra'
 --  exec dbo.SP_OCCURS2  'a', @gcString , @nOccurs output  --  Displays 5
 --  Attention !!!
 --  This procedure counts the 'occurs' excluding  overlaps !
 --  exec dbo.SP_OCCURS2  'ABCA', 'ABCABCABCA', @nOccurs output --  Displays 2
 -- 1 occurrence of substring 'ABCA  .. BCABCA' 
 -- 2 occurrence of substring 'ABCABC... ABCA' 
 -- procedure the functionality of which correspond to the  Visual FoxPro function 
 -- See Also SP_OCCURS()  
CREATE procedure SP_OCCURS2
@cSearchExpression nvarchar(4000), @cExpressionSearched nvarchar(4000), @tnOutcome smallint output
as
     set nocount on
     declare @start_location smallint, @lenSearchExpression smallint
     select  @lenSearchExpression = datalength(@cSearchExpression)/2 -- for unicode
     select  @start_location = -1 - @lenSearchExpression,   @tnOutcome = -1
     while @start_location <> 0
       begin
          select  @tnOutcome = @tnOutcome + 1, @start_location  = @start_location + @lenSearchExpression
          exec dbo.SP_CHARINDEX_BIN @cSearchExpression, @cExpressionSearched, @start_location output
       end
   select @tnOutcome        
GO


 -- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com 
 -- SP_PADL(), SP_PADR(), SP_PADC() Stored Procedures
 -- Returns a string from an expression, padded with spaces or characters to a specified length on the left or right sides, or both.
 -- SP_PADL(@eExpression, @nResultSize [, @cPadCharacter]) -Or-
 -- SP_PADR(@eExpression, @nResultSize [, @cPadCharacter]) -Or-
 -- SP_PADC(@eExpression, @nResultSize [, @cPadCharacter])
 -- Return Values nvarchar(4000)
 -- Parameters
 -- @eExpression nvarchar(4000) Specifies the expression to be padded.
 -- @nResultSize  smallint Specifies the total number of characters in the expression after it is padded. 
 -- @cPadCharacter nvarchar(4000) Specifies the value to use for padding. This value is repeated as necessary to pad the expression to the specified number of characters. 
 -- If you omit @cPadCharacter, spaces (ASCII character 32) are used for padding. 
 -- Remarks
 -- SP_PADL() inserts padding on the left, SP_PADR() inserts padding on the right, and SP_PADC() inserts padding on both sides.
 -- Example
--  declare @gcString  nvarchar(4000)
--  select @gcString  = 'TITLE' 
--  exec dbo.SP_PADL @gcString output, 40, default
--  exec dbo.SP_PADL @gcString output, 40, '=!='
--  exec dbo.SP_PADR @gcString output, 40, '=+='
--  exec dbo.SP_PADC @gcString output, 40, '=~' 
CREATE procedure SP_PADC
@cString nvarchar(4000) output, @nLen smallint, @cPadCharacter nvarchar(4000) = ' ' 
as
    set nocount on
    declare @length smallint, @lengthPadCharacter smallint
    if @cPadCharacter is NULL or  datalength(@cPadCharacter) = 0
        set @cPadCharacter = space(1)     
    select  @length  = datalength(@cString)/2 -- for unicode
    select  @lengthPadCharacter  = datalength(@cPadCharacter)/2 -- for unicode

	if @length >= @nLen
	   set  @cString = left(@cString, @nLen)
	else
	   begin
              declare @nLeftLen smallint, @nRightLen smallint
              set @nLeftLen = (@nLen - @length )/2            -- Quantity of characters, added at the left
              set @nRightLen  =  @nLen - @length - @nLeftLen  -- Quantity of characters, added on the right
              set @cString = left(replicate(@cPadCharacter, ceiling(@nLeftLen/@lengthPadCharacter) + 2), @nLeftLen)+ @cString + left(replicate(@cPadCharacter, ceiling(@nRightLen/@lengthPadCharacter) + 2), @nRightLen)
	   end
 
     select  @cString
GO

 -- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
 -- SP_PADL(), SP_PADR(), SP_PADC() Stored Procedures
 -- Returns a string from an expression, padded with spaces or characters to a specified length on the left or right sides, or both.
 -- SP_PADL similar to the Oracle function PL/SQL  LPAD 
CREATE procedure SP_PADL
@cString nvarchar(4000) output, @nLen smallint, @cPadCharacter nvarchar(4000) = ' ' 
as
       set nocount on
       declare @length smallint, @lengthPadCharacter smallint
       if @cPadCharacter is NULL or  datalength(@cPadCharacter) = 0
         set @cPadCharacter = space(1)     
       select  @length = datalength(@cString)/2 -- for unicode
       select  @lengthPadCharacter = datalength(@cPadCharacter)/2 -- for unicode

       if @length >= @nLen
          set  @cString = left(@cString, @nLen)
       else
    	  begin
              declare @nLeftLen smallint
              set @nLeftLen = @nLen - @length  -- Quantity of characters, added at the left
              set @cString = left(replicate(@cPadCharacter, ceiling(@nLeftLen/@lengthPadCharacter) + 2), @nLeftLen)+ @cString
          end

       select  @cString
GO

 -- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
 -- SP_PADL(), SP_PADR(), SP_PADC() Stored Procedures
 -- Returns a string from an expression, padded with spaces or characters to a specified length on the left or right sides, or both.
 -- SP_PADR similar to the Oracle function PL/SQL RPAD 
CREATE procedure SP_PADR
@cString nvarchar(4000) output, @nLen smallint, @cPadCharacter nvarchar(4000) = ' ' 
as
       set nocount on
       declare @length smallint, @lengthPadCharacter smallint
       if @cPadCharacter is NULL or  datalength(@cPadCharacter) = 0
         set @cPadCharacter = space(1)     
       select  @length  = datalength(@cString)/2 -- for unicode
       select  @lengthPadCharacter  = datalength(@cPadCharacter)/2 -- for unicode

       if @length >= @nLen
          set  @cString = left(@cString, @nLen)
       else
          begin
             declare  @nRightLen smallint
             set @nRightLen  =  @nLen - @length -- Quantity of characters, added on the right
             set @cString =  @cString + left(replicate(@cPadCharacter, ceiling(@nRightLen/@lengthPadCharacter) + 2), @nRightLen)
    	  end

       select  @cString    	  
GO

-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
-- SP_CHRTRAN() Stored Procedure
-- Replaces each character in a character expression that matches a character in a second character expression with the corresponding character in a third character expression.
-- SP_CHRTRAN  (@cExpressionSearched,   @cSearchExpression,  @cReplacementExpression)
-- Return Values nvarchar 
-- Parameters
-- @cSearchedExpression   Specifies the expression in which SP_CHRTRAN( ) replaces characters. 
-- @cSearchExpression  Specifies the expression containing the characters SP_CHRTRAN( ) looks for in @cSearchedExpression. 
-- @cReplacementExpression Specifies the expression containing the replacement characters. 
-- If a character in@cSearchExpression is found in @cSearchedExpression, the character in @cSearchedExpression is replaced by a character from @cReplacementExpression
-- that is in the same position in @cReplacementExpression as the respective character in @cSearchExpression. 
-- If @cReplacementExpression has fewer characters than @cSearchExpression, the additional characters in @cSearchExpression are deleted from @cSearchedExpression. 
-- If @cReplacementExpression has more characters than @cSearchExpression, the additional characters in @cReplacementExpression are ignored. 
-- Remarks
-- SP_CHRTRAN() translates the character expression @cSearchedExpression using the translation expressions @cSearchExpression and @cReplacementExpression and returns the resulting character string.
-- SP_CHRTRAN similar to the Oracle function PL/SQL TRANSLATE
-- Example
-- declare @gcString  nvarchar(4000)
-- select @gcString  = 'ABCDEF' 
-- exec dbo.SP_CHRTRAN @gcString  output, 'ACE', 'XYZ'      --  Displays XBYDZF
-- select @gcString  = 'ABCDEF' 
-- exec dbo.SP_CHRTRAN @gcString  output, 'ACE', 'XYZQRST'  --  Displays XBYDZF
-- See Also SP_STRFILTER()  
-- procedure the  functionality of which correspond  to the  Visual FoxPro function  
CREATE procedure SP_CHRTRAN
@cExpressionSearched nvarchar(4000) output,  @cSearchExpression nvarchar(256),  @cReplacementExpression nvarchar(256)
as
      set nocount on
      declare @lenExpressionSearched smallint, @lenSearchExpression smallint, @lenReplacementExpression smallint,
              @i  smallint,  @j  smallint,  @cExpressionTranslated  nvarchar(4000), @cSymbol nchar(1)
      
      select  @cExpressionTranslated = N'',  @i = 1, 
                 @lenExpressionSearched =  datalength(@cExpressionSearched)/2 ,     -- for unicode
                 @lenSearchExpression =  datalength(@cSearchExpression)/2 ,         -- for unicode
                 @lenReplacementExpression =  datalength(@cReplacementExpression)/2 -- for unicode
    
       if @lenReplacementExpression > @lenSearchExpression
         select @cReplacementExpression = left(@cReplacementExpression, @lenSearchExpression),   @lenReplacementExpression = @lenSearchExpression

       while @i  <=   @lenExpressionSearched
          begin
             select  @cSymbol = substring(@cExpressionSearched, @i, 1), @j = 1
             exec dbo.SP_CHARINDEX_BIN @cSymbol, @cSearchExpression, @j output 
              if  @j  > 0
                   select  @cExpressionTranslated = @cExpressionTranslated + substring(@cReplacementExpression, @j , 1)
               else
                  select  @cExpressionTranslated = @cExpressionTranslated +  @cSymbol
             select   @i =  @i + 1 
          end

   select @cExpressionSearched =  @cExpressionTranslated
   select @cExpressionSearched
GO

-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
-- SP_STRFILTER() Stored Procedure
-- Removes all characters from a string except those specified.
-- SP_STRFILTER(@cExpressionSearched, @cSearchExpression)
-- Return Values nvarchar 
-- Parameters
-- @cExpressionSearched  Specifies the character string to search.
-- @cSearchExpression Specifies the characters to search for and retain in @cExpressionSearched.
-- Remarks
-- SP_STRFILTER( ) removes all the characters from @cExpressionSearched that are not in @cSearchExpression, then returns the characters that remain.
-- Example
-- declare @gcString  nvarchar(4000)
-- select @gcString  = 'asdfghh5hh1jk6f3b7mn8m3m0m6' 
-- exec dbo.SP_STRFILTER @gcString output, '0123456789'  --  Displays 516378306
-- select @gcString  = 'ABCDABCDABCD' 
-- exec dbo.SP_STRFILTER @gcString output, 'AB'          --  Displays ABABAB
-- See Also SP_CHRTRAN()  
-- procedure the functionality of which correspond  to the Foxtools function ( Foxtools is a Visual FoxPro API library) 
CREATE procedure SP_STRFILTER
@cExpressionSearched nvarchar(4000) output, @cSearchExpression nvarchar(256)
as
      set nocount on
      declare @len smallint,  @i  smallint, @StrFiltred  nvarchar(4000), @cSymbol nchar(1), @nWhere smallint 
      select  @StrFiltred = N'', @i = 1,  @len = datalength(@cExpressionSearched)/2 -- for unicode

      while  @i  <=  @len
          begin
               select  @cSymbol = substring(@cExpressionSearched, @i, 1),  @nWhere = 1
               exec dbo.SP_CHARINDEX_BIN @cSymbol, @cSearchExpression, @nWhere output
               if  @nWhere > 0
                     select  @StrFiltred = @StrFiltred +  @cSymbol
               select @i  =   @i  + 1
          end

     select @cExpressionSearched = @StrFiltred
     
     select @cExpressionSearched
GO


-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
-- SP_STRTRAN() Stored Procedure
-- Searches a character expression for occurrences of a second character expression,
-- and then replaces each occurrence with a third character expression.
-- SP_STRTRAN  (@cSearched, @cExpressionSought , [@cReplacement]
-- [, @nStartOccurrence] [, @nNumberOfOccurrences] [, @nFlags])
-- Return Values nvarchar 
-- Parameters
-- @cSearched         Specifies the character expression that is searched.
-- @cExpressionSought Specifies the character expression that is searched for in @cSearched.
-- @cReplacement      Specifies the character expression that replaces every occurrence of @cExpressionSought in @cSearched.
-- If you omit @cReplacement, every occurrence of @cExpressionSought is replaced with the empty string. 
-- @nStartOccurrence  Specifies which occurrence of @cExpressionSought is the first to be replaced.
-- For example, if @nStartOccurrence is 4, replacement begins with the fourth occurrence of @cExpressionSought in @cSearched and the first three occurrences of @cExpressionSought remain unchanged.
-- The occurrence where replacement begins defaults to the first occurrence of @cExpressionSought if you omit @nStartOccurrence. 
-- @nNumberOfOccurrences  Specifies the number of occurrences of @cExpressionSought to replace.
-- If you omit @nNumberOfOccurrences, all occurrences of @cExpressionSought, starting with the occurrence specified with @nStartOccurrence, are replaced. 
-- @nFlags  Specifies the case-sensitivity of a search according to the following values:
---------------------------------------------------------------------------------------------------------------------------------------             
-- @nFlags     Description 
-- 0 (default) Search is case-sensitive, replace is with exact @cReplacement string.
-- 1           Search is case-insensitive, replace is with exact @cReplacement string. 
-- 2           Search is case-sensitive; replace is with the case of @cReplacement changed to match the case of the string found.
--             The case of @cReplacement will only be changed if the string found is all uppercase, lowercase, or proper case. 
-- 3           Search is case-insensitive; replace is with the case of @cReplacement changed to match the case of the string found.
--             The case of @cReplacement will only be changed if the string found is all uppercase, lowercase, or proper case. 
---------------------------------------------------------------------------------------------------------------------------------------             
-- Remarks
-- You can specify where the replacement begins and how many replacements are made.
-- SP_STRTRAN( ) returns the resulting character string. 
-- Specify –1 for optional parameters you want to skip over if you just need to specify the @nFlags setting.
-- Example
-- declare @gcString  nvarchar(4000)
-- select @gcString  = 'ABCDEF' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'ABC', 'XYZ',-1,-1,0      --  Displays XYZDEF
-- select @gcString  = 'ABCDEF' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'ABC', default,-1,-1,0    --  Displays DEF
-- select @gcString  = 'ABCDEFABCGHJabcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'ABC', default,2,-1,0      --  Displays ABCDEFGHJabcQWE
-- select @gcString  = 'ABCDEFABCGHJabcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'ABC', default,2,-1,1      --  Displays ABCDEFGHJQWE
-- select @gcString  = 'ABCDEFABCGHJabcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'ABC', 'XYZ',  2, 1, 1      --  Displays ABCDEFXYZGHJabcQWE
-- select @gcString  = 'ABCDEFABCGHJabcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'ABC', 'XYZ',  2, 3, 1      --  Displays ABCDEFXYZGHJXYZQWE
-- select @gcString  = 'ABCDEFABCGHJabcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'ABC', 'XYZ',  2, 1, 2      --  Displays ABCDEFXYZGHJabcQWE
-- select @gcString  = 'ABCDEFABCGHJabcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'ABC', 'XYZ',  2, 3, 2      --  Displays ABCDEFXYZGHJabcQWE
-- select @gcString  = 'ABCDEFABCGHJabcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'ABC', 'xyZ',  2, 1, 2      --  Displays ABCDEFXYZGHJabcQWE
-- select @gcString  = 'ABCDEFABCGHJabcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'ABC', 'xYz',  2, 3, 2      --  Displays ABCDEFXYZGHJabcQWE
-- select @gcString  = 'ABCDEFAbcCGHJAbcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'Aab', 'xyZ',  2, 1, 2     --  Displays ABCDEFAbcCGHJAbcQWE
-- select @gcString  = 'abcDEFabcGHJabcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'abc', 'xYz',  2, 3, 2      --  Displays abcDEFxyzGHJxyzQWE
-- select @gcString  = 'ABCDEFAbcCGHJAbcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'Aab', 'xyZ',  2, 1, 3     --  Displays ABCDEFAbcCGHJAbcQWE
-- select @gcString  = 'ABCDEFAbcGHJabcQWE' 
-- exec  dbo.SP_STRTRAN  @gcString  output, 'abc', 'xYz',  1, 3, 3      --  Displays XYZDEFXyzGHJxyzQWE
-- See Also replace(), SP_CHRTRAN()  
-- procedure the functionality of which correspond  to the  Visual FoxPro function  
CREATE procedure SP_STRTRAN 
@cSearched nvarchar(4000) output,  @cExpressionSought nvarchar(4000), @cReplacement nvarchar(4000) = N'',
@nStartOccurrence smallint = -1, @nNumberOfOccurrences smallint = -1, @nFlags tinyint = 0
as
   set nocount on
   declare @StartPart nvarchar(4000),  @FinishPart nvarchar(4000),  @nAtStartOccurrence smallint, @nAtFinishOccurrence smallint, @LencSearched smallint,  @LenExpressionSought smallint

   select   @StartPart = N'',  @FinishPart = N'',   @nAtStartOccurrence = 0, @nAtFinishOccurrence = 0,
            @LencSearched  = datalength(@cSearched)/2 ,  -- for unicode
            @LenExpressionSought  = datalength(@cExpressionSought)/2 -- for unicode

if @nStartOccurrence = -1
  select @nStartOccurrence = 1

if @nFlags in ( 0, 2)
    begin 
       select  @nAtStartOccurrence = @nStartOccurrence, @nAtFinishOccurrence = case  @nNumberOfOccurrences  when -1 then 0  else @nStartOccurrence + @nNumberOfOccurrences  end
       exec dbo.SP_AT2 @cExpressionSought, @cSearched, @nAtStartOccurrence out 
       if @nAtFinishOccurrence > 0
           exec dbo.SP_AT2 @cExpressionSought,  @cSearched, @nAtFinishOccurrence out
    end  
else
if @nFlags in (1, 3)
        begin 
           select  @nAtStartOccurrence = @nStartOccurrence, @nAtFinishOccurrence = case  @nNumberOfOccurrences  when -1 then 0  else @nStartOccurrence + @nNumberOfOccurrences  end
           exec dbo.SP_ATC2 @cExpressionSought, @cSearched, @nAtStartOccurrence out 
           if @nAtFinishOccurrence > 0
             exec dbo.SP_ATC2 @cExpressionSought,  @cSearched, @nAtFinishOccurrence out
        end  
else 
  select @cSearched  =  'Error, sixth parameter must be 0, 1, 2, 3 ! '

   if @nAtStartOccurrence > 0
      begin
         select @StartPart = left(@cSearched, @nAtStartOccurrence - 1)
           if  @nAtFinishOccurrence  > 0
                   select @FinishPart =  right(@cSearched,  @LencSearched - @nAtFinishOccurrence + 1) , @cSearched = substring(@cSearched,  @nAtStartOccurrence, @nAtFinishOccurrence - @nAtStartOccurrence )
           else           
                 select  @cSearched = substring(@cSearched,  @nAtStartOccurrence, @LencSearched - @nAtStartOccurrence + 1)
     
          if @nFlags = 0  or (@nFlags = 2 and datalength(@cReplacement) = 0)
                exec  dbo.SP_REPLACE @cSearched output, @cExpressionSought, @cReplacement, 0
          else
                if @nFlags = 1  or (@nFlags = 3 and datalength(@cReplacement) = 0)
                     exec  dbo.SP_REPLACE @cSearched output, @cExpressionSought, @cReplacement, 1
               else
                      if @nFlags in (2,  3)
                            begin
                                  declare @cNewSearched  nvarchar(4000) , @cNewExpressionSought  nvarchar(4000), @cNewReplacement   nvarchar(4000), 
                                               @nAtPreviousOccurrence smallint, @occurs2 smallint, @i smallint, @j smallint
                                  select @i = 1,  @cNewSearched = N'',  @nAtPreviousOccurrence =  1,
                                             @LencSearched  = datalength(@cSearched)/2 ,  -- for unicode
                                             @nAtStartOccurrence =  1 - @LenExpressionSought
                                             if  @nFlags = 3
                                                select @occurs2 = ( datalength(@cSearched) - datalength(replace(lower(@cSearched), lower(@cExpressionSought),  N'')))  / datalength(@cExpressionSought)
                                             else 
                                                exec dbo.SP_OCCURS2  @cExpressionSought, @cSearched,  @occurs2 output     
                                   while @i  <= @occurs2
                                        begin
                                              if  @nFlags = 3
                                                  select  @nAtStartOccurrence = charindex(lower(@cExpressionSought), lower(@cSearched),  @nAtStartOccurrence + @LenExpressionSought)
                                               else    
                                                   begin
                                                      select  @nAtStartOccurrence = @nAtStartOccurrence + @LenExpressionSought 
                                                      exec dbo.SP_CHARINDEX_BIN  @cExpressionSought, @cSearched, @nAtStartOccurrence output               
                                                   end
                                              select @cNewSearched  = @cNewSearched + case
                                                                                                                          when @i > 1
                                                                                                                          then  substring(@cSearched,  @nAtPreviousOccurrence + @LenExpressionSought, @nAtStartOccurrence  - (@nAtPreviousOccurrence + @LenExpressionSought) )  
                                                                                                                          else  left(@cSearched, @nAtStartOccurrence - 1)  end ,
                                                        @cNewExpressionSought = substring(@cSearched,  @nAtStartOccurrence, @LenExpressionSought)
                                              select @cNewReplacement  =  case
                                                                                                when  lower(@cNewExpressionSought) = upper(@cNewExpressionSought)  -- no letters in string
                                                                                                then  @cReplacement
                                                                                                when  @cNewExpressionSought = upper(@cNewExpressionSought) 
                                                                                                then upper(@cReplacement)
                                                                                                when  @cNewExpressionSought = lower(@cNewExpressionSought) 
                                                                                                then  lower(@cReplacement)
                                                                                                else NULL  end
                                              if  @cNewReplacement is NULL
                                                     if upper(substring( @cNewExpressionSought, 1, 1) )  <> lower(substring( @cNewExpressionSought, 1, 1) )  and
                                                           upper(substring( @cNewExpressionSought, 1, 1) )  =  substring( @cNewExpressionSought, 1, 1)   and
                                                           lower(substring( @cNewExpressionSought, 2,  @LenExpressionSought - 1) )  = substring( @cNewExpressionSought, 2,  @LenExpressionSought - 1)
                                                                      select @cNewReplacement  =  upper(substring( @cReplacement, 1, 1) ) +  lower(substring( @cReplacement, 2, datalength(@cReplacement)/2)) -- for unicode
                                               else
                                                    begin
                                                          select @j = 1
                                                           while @j   <= @LenExpressionSought
                                                                begin  
                                                                      if upper(substring( @cNewExpressionSought, @j, 1) )  <> lower(substring( @cNewExpressionSought, @j, 1) )   -- this is letter    
                                                                           begin 
                                                                                if substring( @cNewExpressionSought, @j, 1)  =  lower(substring( @cNewExpressionSought, @j, 1) ) 
                                                                                    select @cNewReplacement  =   lower(@cReplacement)
                                                                               else
                                                                                    select @cNewReplacement  =  @cReplacement
                                                                                break
                                                                          end
                                                                      select @j = @j + 1                 
                                                                end
                                                    end
                                               if  @cNewReplacement is NULL
                                                     select @cNewReplacement  =  @cReplacement
                                              select @cNewSearched  = @cNewSearched + @cNewReplacement, @nAtPreviousOccurrence = @nAtStartOccurrence, @i = @i + 1
                                        end
                                  select  @cSearched = @cNewSearched  +  right(@cSearched,  @LencSearched +1 - (@nAtStartOccurrence + @LenExpressionSought) )
                            end
   end
  select @cSearched =  @StartPart + @cSearched + @FinishPart

  select @cSearched
GO


 -- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
 -- SP_PROPER( ) Stored Procedure
 -- Returns from a character expression a string capitalized as appropriate for proper names.
 -- SP_PROPER(@cExpression)
 -- Returns Values nvarchar(4000)
 -- Parameters
 -- @cExpression nvarchar(4000) Specifies the character expression from which SP_PROPER( ) returns a capitalized character string. 
 -- Example
 --  declare @gcExpr1 nvarchar(4000), @gcExpr2 nvarchar(4000)
 --  select @gcExpr1 = 'Visual Basic.NET', @gcExpr2 = 'Unfortunately, I am using SQL 7 which does not support the CREATE Function syntax.'
 --  exec dbo.SP_PROPER  @gcExpr1  output --  Displays 'Visual Basic.net'
 --  exec dbo.SP_PROPER  @gcExpr2  output --  Displays 'Unfortunately, I Am Using Sql 7 Which Does Not Support The Create Function Syntax.' 
 -- Remarks
 -- SP_PROPER similar to the Oracle function PL/SQL  INITCAP 
CREATE procedure SP_PROPER
@expression nvarchar(4000) output
as
      set nocount on
      declare @i  smallint,   @properexpression nvarchar(4000),  @lenexpression  smallint, @flag bit, @symbol nchar(1)
      select  @flag = 1, @i = 1, @properexpression = '', @lenexpression =  datalength(@expression)/2 -- for unicode

      while  @i <= @lenexpression
          begin
             select @symbol = lower(substring(@expression, @i, 1) )
               if @symbol in (nchar(32), nchar(9), nchar(10), nchar(11), nchar(12), nchar(13),  nchar(160)) and ascii(@symbol) <> 0
                   select @flag = 1
               else
                   if @flag = 1
                       select @symbol = upper(@symbol),  @flag = 0 
              select  @properexpression = @properexpression + @symbol,  @i = @i + 1 
          end

     select  @expression = @properexpression

     select  @expression
GO


 -- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com 
 -- SP_GETWORDCOUNT() Stored Procedure Counts the words in a string.
 -- SP_GETWORDCOUNT(@cString[, @cDelimiters])
 -- Parameters
 -- @cString  nvarchar(4000) - Specifies the string whose words will be counted. 
 -- @cDelimiters nvarchar(256) - Optional. Specifies one or more optional characters used to separate words in @cString.
 -- The default delimiters are space, tab, carriage return, and line feed. Note that SP_GETWORDCOUNT( ) uses each of the characters in @cDelimiters as individual delimiters, not the entire string as a single delimiter. 
 -- Return Value smallint 
 -- Remarks SP_GETWORDCOUNT() by default assumes that words are delimited by spaces or tabs. If you specify another character as delimiter, this function ignores spaces and tabs and uses only the specified character.
 -- If you use 'AAA aaa, BBB bbb, CCC ccc.' as the target string for dbo.SP_GETWORDCOUNT(), you can get all the following results.
 --  declare @cString nvarchar(4000), @nWordcount smallint 
 --  select @cString = 'AAA aaa, BBB bbb, CCC ccc.'
 --  exec dbo.SP_GETWORDCOUNT @nWordcount output, @cString, default       --  Displays    6 - character groups, delimited by ' '
 --  exec dbo.SP_GETWORDCOUNT @nWordcount output, @cString, ','           --  Displays    3 - character groups, delimited by ','
 --  exec dbo.SP_GETWORDCOUNT @nWordcount output, @cString, '.'           --  Displays    1 - character group, delimited by '.'
 -- See Also SP_GETWORDNUM() Stored Procedure   
 -- procedure the  functionality of which correspond  to the  Visual FoxPro function  
CREATE procedure SP_GETWORDCOUNT
@wordcount smallint output, @cString nvarchar(4000), @cDelimiters nvarchar(256) = NULL
as
      set nocount on
      declare @k smallint, @nEndString smallint, @cSymbol nchar(1), @nWhere smallint 
      select  @k = 1, @wordcount = 0, @cDelimiters = isnull(@cDelimiters, nchar(32)+nchar(9)+nchar(10)+nchar(13)), -- if no break string is specified, the function uses spaces, tabs, carriage return and line feed to delimit words.
              @nEndString = 1 + datalength(@cString)/2 -- for unicode

      while 1 > 0
         begin
           select  @cSymbol = substring(@cString, @k, 1), @nWhere = 1
           exec dbo.SP_CHARINDEX_BIN @cSymbol, @cDelimiters, @nWhere output
           if @nWhere > 0  and @nEndString > @k  -- skip opening break characters, if any
             set @k = @k + 1
           else
            break     
         end
         
      if @k < @nEndString
         begin
            set @wordcount = 1 -- count the one we are in now count transitions from 'not in word' to 'in word' 
                               -- if the current character is a break char, but the next one is not, we have entered a new word
            while @k < @nEndString
               begin
                  if @k +1 < @nEndString 
                      begin                                 
                         select  @cSymbol = substring(@cString, @k, 1), @nWhere = 1
                         exec dbo.SP_CHARINDEX_BIN @cSymbol, @cDelimiters, @nWhere output
                         if @nWhere > 0
                              begin                                                          
                                select  @cSymbol = substring(@cString, @k+1, 1), @nWhere = 1
                                exec dbo.SP_CHARINDEX_BIN @cSymbol, @cDelimiters, @nWhere output
                                if @nWhere = 0
                                  select @wordcount = @wordcount + 1, @k = @k + 1 -- Skip over the first character in the word. We know it cannot be a break character.
                              end
                      end
                 set @k = @k + 1
               end
         end

     select @wordcount
GO


 -- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   
 -- SP_GETWORDNUM() Stored Procedure 
 -- Returns a specified word from a string.
 -- SP_GETWORDNUM(@cString, @nIndex[, @cDelimiters])
 -- Parameters @cString  nvarchar(4000) - Specifies the string to be evaluated 
 -- @nIndex smallint - Specifies the index position of the word to be returned. For example, if @nIndex is 3, SP_GETWORDNUM( ) returns the third word (if @cString contains three or more words). 
 -- @cDelimiters nvarchar(256) - Optional. Specifies one or more optional characters used to separate words in @cString.
 -- The default delimiters are space, tab, carriage return, and line feed. Note that GetWordNum( ) uses each of the characters in @cDelimiters as individual delimiters, not the entire string as a single delimiter. 
 -- Return Value nvarchar(4000)
 -- Remarks Returns the word at the position specified by @nIndex in the target string, @cString. If @cString contains fewer than @nIndex words, SP_GETWORDNUM( ) returns an empty string.
 -- Example
 -- declare @gcExpr1 nvarchar(4000), @gcExpr2 nvarchar(4000)
 -- select @gcExpr1 = 'Visual Basic.NET', @gcExpr2 = 'Unfortunately, I am using SQL 7 which does not support the CREATE Function syntax.'
 -- exec dbo.SP_GETWORDNUM @gcExpr1 out, 1       --  Displays 'Visual'
 -- exec dbo.SP_GETWORDNUM @gcExpr2 out, 5, ' '  --  Displays    'SQL'
 -- See Also
 -- SP_GETWORDCOUNT() Stored Procedure 
 -- procedure the functionality of which correspond  to the Visual FoxPro function  
CREATE procedure SP_GETWORDNUM
@cString nvarchar(4000) output, @nIndex smallint, @cDelimiters nvarchar(256) = NULL
as
      set nocount on
      declare @i smallint,  @j smallint, @k smallint, @l smallint, @lmin smallint, @nEndString smallint, @LenDelimiters smallint, @cWord  nvarchar(4000), @cSymbol nchar(1), @nWhere smallint 
      select  @i = 1, @k = 1, @l = 0, @cWord = '', @cDelimiters = isnull(@cDelimiters,  nchar(32)+nchar(9)+nchar(10)+nchar(13)), -- if no break string is specified, the function uses spaces, tabs, carriage return and line feed to delimit words.
              @nEndString = 1 + datalength(@cString)/2 ,  -- for unicode
              @LenDelimiters = datalength(@cDelimiters)/2 -- for unicode

      while @i <= @nIndex
         begin
            while 1 > 0
               begin            
                 select  @cSymbol = substring(@cString, @k, 1), @nWhere = 1
                 exec dbo.SP_CHARINDEX_BIN @cSymbol, @cDelimiters, @nWhere output
                 if @nWhere > 0 and @nEndString > @k  -- skip opening break characters, if any
                     set @k = @k + 1
                  else
                     break   
               end  

            if  @k >= @nEndString
               break

            select @j = 1, @lmin = @nEndString -- find next break character it marks the end of this word
            while @j <= @LenDelimiters
               begin
                  select  @cSymbol = substring(@cDelimiters, @j, 1), @l = @k
                  exec dbo.SP_CHARINDEX_BIN @cSymbol, @cString,  @l output
                  select @j = @j + 1
                  if @l > 0 and @lmin > @l 
                     set @lmin = @l
               end

            if @i = @nIndex -- this is the actual word we are looking for
               begin
                  set @cWord =  substring(@cString, @k, @lmin-@k)
                  break
               end
             set @k = @lmin + 1

             if (@k >= @nEndString)
                 break
             set @i = @i + 1
         end

     select @cString =  @cWord

     select @cString
GO


 -- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com 
 -- SP_GETALLWORDS() Stored Procedure Inserts the words from a string into the table.
 -- SP_GETALLWORDS(@cString[, @cDelimiters])
 -- Parameters
 -- @cString  nvarchar(4000) - Specifies the string whose words will be inserted into the cursor passed as parameter. 
 -- @cDelimiters nvarchar(256) - Optional. Specifies one or more optional characters used to separate words in @cString.
 -- The default delimiters are space, tab, carriage return, and line feed. Note that SP_GETALLWORDS( ) uses each of the characters in @cDelimiters as individual delimiters, not the entire string as a single delimiter. 
 -- Return Value table 
 -- Remarks SP_GETALLWORDS() by default assumes that words are delimited by spaces or tabs. If you specify another character as delimiter, this function ignores spaces and tabs and uses only the specified character.
 -- Example
 --  declare @ResCursor cursor, @lcString nvarchar(4000), @WORDNUM  smallint, @WORD nvarchar(4000), @STARTOFWORD smallint, @LENGTHOFWORD  smallint
 --  select  @lcString = 'The default delimiters are space, tab, carriage return, and line feed. If you specify another character as delimiter, this function ignores spaces and tabs and uses only the specified character.'
 --  exec  dbo.SP_GETALLWORDS @GETALLWORDS = @ResCursor output, @cString = @lcString 
 --  fetch next from @ResCursor into @WORDNUM, @WORD, @STARTOFWORD, @LENGTHOFWORD 
 --  while (@@FETCH_STATUS=0)
 --    begin
 --       select @WORDNUM, @WORD, @STARTOFWORD, @STARTOFWORD
 --       fetch next from @ResCursor into @WORDNUM, @WORD, @STARTOFWORD, @LENGTHOFWORD
 --    end
 --  close @ResCursor
 --  deallocate @ResCursor          
 -- See Also SP_GETWORDNUM() , SP_GETWORDCOUNT() Stored Procedures   
CREATE procedure SP_GETALLWORDS 
@GETALLWORDS cursor varying output , 
@cString nvarchar(4000),   @cDelimiters    nvarchar(256) = NULL
as
         set nocount on
         create table #GETALLWORDS (WORDNUM  smallint, WORD nvarchar(4000), STARTOFWORD smallint, LENGTHOFWORD  smallint)
         declare @k smallint, @wordcount smallint, @nEndString smallint, @BegOfWord smallint, @flag bit, @cSymbol nchar(1), @nWhere smallint 

         select   @k = 1, @wordcount = 1,  @BegOfWord = 1,  @flag = 0,  @cString =  isnull(@cString, ''), 
                  @cDelimiters = isnull(@cDelimiters, nchar(32)+nchar(9)+nchar(10)+nchar(13)), -- if no break string is specified, the function uses spaces, tabs, carriage return and line feed to delimit words.
                  @nEndString = 1 + datalength(@cString)/2 -- for unicode

                     while 1 > 0
                         begin
                                if  @k - @BegOfWord  >  0 
                                     begin
                                          insert into #GETALLWORDS (WORDNUM,  WORD, STARTOFWORD, LENGTHOFWORD)    values( @wordcount, substring(@cString, @BegOfWord, @k-@BegOfWord), @BegOfWord,  @k-@BegOfWord )   -- previous word
                                          select  @wordcount = @wordcount + 1,  @BegOfWord = @k 
                                      end   
                                 if  @flag  = 1 
                                        break

                                 while 1 > 0
                                     begin
                                        select  @cSymbol = substring(@cString, @k, 1), @nWhere = 1
                                        exec dbo.SP_CHARINDEX_BIN @cSymbol, @cDelimiters, @nWhere output
                                        if @nWhere > 0 and @nEndString > @k  -- skip opening break characters, if any
                                           select @k = @k + 1,  @BegOfWord  = @BegOfWord +  1
                                        else
                                           break   
                                      end
                                 while 1 > 0
                                     begin
                                        select  @cSymbol = substring(@cString, @k, 1), @nWhere = 1
                                        exec dbo.SP_CHARINDEX_BIN @cSymbol, @cDelimiters, @nWhere output
                                        if @nWhere = 0  and @nEndString > @k   -- skip  the character in the word
                                           select @k = @k + 1
                                        else
                                           break   
                                     end
                                 if  @k >= @nEndString 
                                        select  @flag  = 1
                          end 

       set @GETALLWORDS =  cursor  static  for  select  *  from  #GETALLWORDS
       open @GETALLWORDS
GO

 -- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com 
 -- SP_GETALLWORDS2() Stored Procedure Inserts the words from a string into the table.
 -- SP_GETALLWORDS2(@cString[, @cStringSplitting])
 -- Parameters
 -- @cString  nvarchar(4000) - Specifies the string whose words will be inserted into the cursor passed as parameter. 
 -- @cStringSplitting nvarchar(256) - Optional. Specifies the string used to separate words in @cString.
 -- The default delimiter is space.
 -- Note that SP_GETALLWORDS2( ) uses  @cStringSplitting as a single delimiter. 
 -- Return Value table 
 -- Remarks SP_GETALLWORDS2() by default assumes that words are delimited by space. If you specify another string as delimiter, this function ignores spaces and uses only the specified string.
 -- Example
 --  declare @ResCursor cursor, @lcString nvarchar(4000), @nIndex smallint, @WORDNUM  smallint, @WORD nvarchar(4000), @STARTOFWORD smallint, @LENGTHOFWORD  smallint
 --  select  @lcString = 'We hold these truths to be self-evident, that all men are created equal, that they are endowed by their Creator with certain unalienable Rights, that among these are Life, Liberty and the pursuit of Happiness.', @nIndex = 30
 --  exec  dbo.SP_GETALLWORDS2 @GETALLWORDS = @ResCursor output, @cString = @lcString 
 --  fetch last from @ResCursor into @WORDNUM, @WORD, @STARTOFWORD, @LENGTHOFWORD
 --  select @WORDNUM --  Displays 35
 --  fetch absolute 1 from @ResCursor into @WORDNUM, @WORD, @STARTOFWORD, @LENGTHOFWORD
 --  while (@@FETCH_STATUS=0)
 --    begin
 --       if @WORDNUM = @nIndex
 --         begin
 --           select @WORD --  Displays 'Liberty'
 --           break
 --         end  
 --        fetch next from @ResCursor into @WORDNUM, @WORD, @STARTOFWORD, @LENGTHOFWORD
 --    end
 --  close @ResCursor
 --  deallocate @ResCursor
 -- See Also SP_GETWORDNUM(), SP_GETWORDCOUNT(), SP_GETALLWORDS()  Stored Procedures   
CREATE procedure SP_GETALLWORDS2
@GETALLWORDS cursor varying output, 
@cString nvarchar(4000), @cStringSplitting  nvarchar(256) = ' '   -- if no break string is specified, the function uses space to delimit words.
as
        set nocount on
        create table #GETALLWORDS (WORDNUM  smallint, WORD nvarchar(4000), STARTOFWORD smallint, LENGTHOFWORD  smallint)
        declare @k smallint,   @BegOfWord smallint,  @wordcount  smallint,  @nEndString smallint,  @nLenSrtingSplitting smallint, @flag bit, @nWhere smallint, @cSubStr nvarchar(4000)

        select   @cStringSplitting = isnull(@cStringSplitting, space(1)) , @nWhere = 1,
                    @cString = isnull(@cString, '') ,
                    @BegOfWord = 1,   @wordcount = 1,  @k = 0 , @flag = 0,
                    @nEndString =  1+  datalength(@cString)/2 ,  -- for unicode
                    @nLenSrtingSplitting =  datalength(@cStringSplitting)/2 -- for unicode

       while  1 > 0 
          begin
             if  @k - @BegOfWord  >  0  
                 begin
                      insert into #GETALLWORDS (WORDNUM,  WORD, STARTOFWORD, LENGTHOFWORD)    values( @wordcount,  substring(@cString,  @BegOfWord , @k - @BegOfWord ) , @BegOfWord,  @k - @BegOfWord)
                      select  @wordcount = @wordcount + 1,  @BegOfWord = @k 
                 end 

             if  @flag  = 1 
                 break

             while 1 > 0
                begin
                  select @cSubStr = substring(@cString, @BegOfWord, @nLenSrtingSplitting),  @nWhere = 1
                  exec dbo.SP_CHARINDEX_BIN  @cSubStr, @cStringSplitting, @nWhere output  --  skip break strings, if any     
                  if @nWhere > 0
                    set  @BegOfWord  = @BegOfWord +  @nLenSrtingSplitting
                  else
                    break
                end

             select   @k  = @BegOfWord
             exec dbo.SP_CHARINDEX_BIN @cStringSplitting , @cString, @k output  

             if  @k = 0 
                select   @k  =  @nEndString,  @flag  = 1
          end

     set @GETALLWORDS =  cursor  static  for  select  *  from  #GETALLWORDS
     open @GETALLWORDS
GO


-- SP_ARABTOROMAN() Returns the character Roman numeral equivalent of a specified numeric expression (from 1 to 3999) 
-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com ,  25 April 2005 or XXV April MMV :-)
-- SP_ARABTOROMAN(@tNum) Return Values varchar(15) Parameters @tNum  number
-- Example
-- declare @cResult varchar(75)
-- exec dbo.SP_ARABTOROMAN @cResult output, 3888 --  Displays MMMDCCCLXXXVIII
-- exec dbo.SP_ARABTOROMAN @cResult output, 1888 --  Displays MDCCCLXXXVIII
-- exec dbo.SP_ARABTOROMAN @cResult output, 1    --  Displays I
-- exec dbo.SP_ARABTOROMAN @cResult output, 234  --  Displays CCXXXIV
-- See also SP_ROMANTOARAB()  
CREATE procedure SP_ARABTOROMAN
@lResult varchar(75) output, @tNum int 
as
         set nocount on
         if @tNum  between 1 and 3999
            begin    
               declare @ROMANNUMERALS char(7), @lnI tinyint, @tcNum  varchar(4)
               select @ROMANNUMERALS = 'IVXLCDM', @tcNum = ltrim(rtrim(cast(@tNum as varchar(4)))), @lResult = ''
               set @lnI = datalength(@tcNum)
               while  @lnI >= 1  
                  begin   
                    set @tNum = cast(substring(@tcNum, datalength(@tcNum)-@lnI+1, 1) as smallint)
                    select @lResult = @lResult + case 
                       when @tNum < 4 then replicate(substring(@ROMANNUMERALS, @lnI*2 - 1, 1),@tNum )
                       when @tNum = 4 or @tNum = 9 then substring(@ROMANNUMERALS, @lnI*2 - 1, 1)+substring(@ROMANNUMERALS, @lnI*2 + case when @tNum = 9 then 1 else 0 end, 1)
                       else substring(@ROMANNUMERALS, @lnI*2, 1)+replicate(substring(@ROMANNUMERALS, @lnI*2 - 1, 1),@tNum -5)
                   end
                   set @lnI = @lnI - 1
               end
            end
         else
           set @lResult = 'Out of range, must be between 1 and 3999'

     select @lResult
GO

-- SP_ROMANTOARAB() Returns the number equivalent of a specified character Roman numeral expression (from I to MMMCMXCIX)
-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com ,  25 April 2005 or XXV April MMV :-)
-- SP_ROMANTOARAB(@tcRomanNumber) Return Values smallint
-- Parameters @tcRomanNumber  varchar(15) Roman number  
-- Example
-- declare  @nResult  smallint 
-- exec dbo.SP_ROMANTOARAB @nResult output, 'MMMDCCCLXXXVIII' --  Displays 3888
-- exec dbo.SP_ROMANTOARAB @nResult output, 'MDCCCLXXXVIII'   --  Displays 1888
-- exec dbo.SP_ROMANTOARAB @nResult output, 'I'               --  Displays 1
-- exec dbo.SP_ROMANTOARAB @nResult output, 'CCXXXIV'         --  Displays 234
-- See also SP_ARABTOROMAN()  
CREATE procedure SP_ROMANTOARAB
@tnOutcome smallint output, @tcRomanNumber varchar(15)
as
      set nocount on
      declare @lnResult smallint, @lcRomanNumber varchar(15), @lnI tinyint, @ROMANNUMERALS char(7)
      select @tcRomanNumber = ltrim(rtrim(upper(@tcRomanNumber))), @ROMANNUMERALS = 'IVXLCDM', @lcRomanNumber = '', @lnI = 1, @lnResult = 0
   
     while  @lnI <= datalength(@tcRomanNumber)
       begin 
         if charindex(substring(@tcRomanNumber, @lnI, 1), @ROMANNUMERALS) > 0
           set @lcRomanNumber = @lcRomanNumber + substring(@tcRomanNumber, @lnI, 1)
         else
           begin
             set @lnResult = -1
             break
            end
         set @lnI =  @lnI + 1
       end
    
     if @lnResult >  -1
       begin
         declare @lnJ tinyint, @lnDelim smallint, @lnK tinyint
         select  @lnK = datalength(@lcRomanNumber), @lnI = 1
   
         while  @lnI <= 4
            begin
              if @lnK = 0
                  break
              set @lnDelim = power(10, @lnI-1)
              if @lnK >= 2 and substring(@lcRomanNumber, @lnK - 1, 2) = (substring(@ROMANNUMERALS, @lnI*2 - 1, 1)+substring(@ROMANNUMERALS, @lnI*2, 1)) -- CD or XL or IV
                select @lnResult = @lnResult + 4*@lnDelim, @lnK = @lnK - 2
              else  
              if @lnK >= 2 and  substring(@lcRomanNumber, @lnK - 1, 2) = (substring(@ROMANNUMERALS, @lnI*2 - 1, 1)+substring(@ROMANNUMERALS, (@lnI+1)*2 - 1, 1)) -- CM or XC or IX
                select @lnResult = @lnResult + 9*@lnDelim, @lnK = @lnK - 2
              else
                begin 
                  set @lnJ = 1
                  while  @lnJ <= 3  -- MMM or CCC or XXX or III
                    begin
                      if  @lnK >=1 and substring(@lcRomanNumber, @lnK, 1) = substring(@ROMANNUMERALS, @lnI*2 - 1, 1)
                        select @lnResult = @lnResult + @lnDelim, @lnK = @lnK - 1
                      set @lnJ =  @lnJ + 1
                    end 
                  if @lnK = 0
                    break
                  if substring(@lcRomanNumber, @lnK, 1) = substring(@ROMANNUMERALS, @lnI*2, 1) -- D or L or V
                    select @lnResult = @lnResult + 5*@lnDelim, @lnK = @lnK - 1
                end 
             set @lnI =  @lnI + 1
            end
         end      
        
        if @lnK > 0
          set @lnResult = -1
     
     select @tnOutcome = @lnResult
     
select @tnOutcome

GO

-- SP_ADDROMANNUMBERS() Stored Procedure is written just FYA
-- Returns the result of addition, subtraction, multiplication or division of two Roman numbers  
-- Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com ,  25 April 2005 or XXV April MMV :-)
-- SP_ADDROMANNUMBERS(@tcRomanNumber1, @tcRomanNumber2, @tcOperator) Return Values varchar(75)
-- Parameters @tcRomanNumber1 varchar(15) Roman number
-- @tcRomanNumber2 varchar(15) Roman number, @tcOperator char(1) operator
-- Example
-- declare @cRomanNumber varchar(75)
-- select  @cRomanNumber = 'IV'
-- exec dbo.SP_ADDROMANNUMBERS @cRomanNumber output, 'VI', '*'           --  Displays XXIV
-- select  @cRomanNumber = 'MMMDCCCLXXXVIII'
-- exec dbo.SP_ADDROMANNUMBERS @cRomanNumber output, 'MDCCCLXXXVIII','-' --  Displays MM
-- select  @cRomanNumber = 'DCCCLXXXVIII'
-- exec dbo.SP_ADDROMANNUMBERS @cRomanNumber output, 'VIII',default      --  Displays DCCCXCVI
-- select  @cRomanNumber = 'DCCCLXXXVIII'
-- exec dbo.SP_ADDROMANNUMBERS @cRomanNumber output, 'VIII','*'          --  Displays Out of range, must be between 1 and 3999
-- select  @cRomanNumber = 'MMMDCCCLXXXVIII'
-- exec dbo.SP_ADDROMANNUMBERS @cRomanNumber output, 'II','/'            --  Displays MCMXLIV
-- See also SP_ROMANTOARAB(), SP_ARABTOROMAN()  
CREATE procedure SP_ADDROMANNUMBERS
@tcRomanNumber1 varchar(75) output, @tcRomanNumber2 varchar(15), @tcOperator char(1)='+' 
as
      set nocount on
      if @tcOperator in ('+','-','*','/')
        begin
           declare @lnN1 int, @lnN2 int
           exec dbo.SP_ROMANTOARAB @lnN1 output, @tcRomanNumber1
           exec dbo.SP_ROMANTOARAB @lnN2 output, @tcRomanNumber2
          if @lnN1 < 0
             set @tcRomanNumber1 = 'Wrong first roman number'
          else 
            if @lnN2 < 0
               set @tcRomanNumber1 = 'Wrong second roman number'
            else   
              begin
                     declare  @SQLString   nvarchar(500), @ParmDefinition   nvarchar(500)
                     select   @SQLString =  'select @lnN1 = '+cast(@lnN1  as nvarchar(10))+ @tcOperator +cast(@lnN2  as nvarchar(10)),   @ParmDefinition  = '@lnN1 int out'   
                     exec sp_executesql @SQLString, @ParmDefinition,  @lnN1 = @lnN1 out
                     exec dbo.SP_ARABTOROMAN @tcRomanNumber1 out,  @lnN1
              end
        end
      else 
            set @tcRomanNumber1 = 'Wrong third parameter, must be +,-,*,/'

           select  @tcRomanNumber1
GO
