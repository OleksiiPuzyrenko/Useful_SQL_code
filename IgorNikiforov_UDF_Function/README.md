
<b><u> Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   </b></u>
<br>
<pre>
 AT()  Returns the beginning numeric position of the nth occurrence of a character expression within
       another character expression, counting from the leftmost character
 RAT() Returns the numeric position of the last (rightmost) occurrence of a character string within 
       another character string 
 OCCURS() Returns the number of times a character expression occurs within another character expression 
 PADL()   Returns a string from an expression, padded with spaces or characters to a specified length on the left side
 PADR()   Returns a string from an expression, padded with spaces or characters to a specified length on the right side
 PADC()   Returns a string from an expression, padded with spaces or characters to a specified length on the both sides
 CHRTRAN()   Replaces each character in a character expression that matches a character in a second character expression
             with the corresponding character in a third character expression.
 STRTRAN()   Searches a character expression for occurrences of a second character expression,
             and then replaces each occurrence with a third character expression.
             Unlike a built-in function replace, STRTRAN has three additional parameters.
 STRFILTER() Removes all characters from a string except those specified. 
 GETWORDCOUNT() Counts the words in a string
 GETWORDNUM()   Returns a specified word from a string
 GETALLWORDS()  Inserts the words from a string into the table
 PROPER() Returns from a character expression a string capitalized as appropriate for proper names
 RCHARINDEX()  Similar to the Transact-SQL function Charindex, with a Right search
 ARABTOROMAN() Returns the character Roman numeral equivalent of a specified numeric expression (from 1 to 3999)
 ROMANTOARAB() Returns the number equivalent of a specified character Roman numeral expression (from I to MMMCMXCIX)
 Examples:  
 
 GETWORDCOUNT, GETWORDNUM
 -------------------------
 select  dbo.GETWORDCOUNT('User-Defined marvellous string Functions Transact-SQL', default)<br>
 select  dbo.GETWORDNUM('User-Defined marvellous string Functions Transact-SQL', 2, default)<br>
  
 CHRTRAN, STRFILTER
 ------------------
 select dbo.CHRTRAN('ABCDEF', 'ACE', 'XYZ')   -- Displays XBYDZF
 select dbo.STRFILTER('ABCDABCDABCD', 'AB')   -- Displays ABABAB
 
 AT, RAT, OCCURS, PROPER  
 -----------------------
 select  dbo.AT ('marvellous', 'User-Defined marvellous string Functions Transact-SQL', default)
 select  dbo.OCCURS ('F', 'User-Defined marvellous string Functions Transact-SQL')
 select  dbo.PROPER ('User-Defined marvellous string Functions Transact-SQL')
 
 PADC, PADR, PADL 
 ----------------
 select  dbo.PADC (' marvellous string Functions', 60, '+*+')
 
 ARABTOROMAN, ROMANTOARAB
 ------------------------
 select dbo.ARABTOROMAN(3888)      -- Displays MMMDCCCLXXXVIII
 select dbo.ROMANTOARAB('CCXXXIV') -- Displays 234
--------------------------------------------------
</pre>

For more information about string UDFs Transact-SQL please visit the <br>
 http://www.universalthread.com/wconnect/wc.dll?LevelExtreme~2,54,33,27115   or <br>
 http://nikiforov.developpez.com/espagnol/  (the Spanish language)<br>
 http://nikiforov.developpez.com/           (the French  language)<br>
 http://nikiforov.developpez.com/allemand/  (the German  language)<br>
 http://nikiforov.developpez.com/italien/   (the Italian language)<br>
 http://nikiforov.developpez.com/portugais/ (the Portuguese language)<br>
 http://nikiforov.developpez.com/roumain/   (the Roumanian  language)<br>
 http://nikiforov.developpez.com/russe/     (the Russian language)<br>
 http://nikiforov.developpez.com/bulgare/   (the Bulgarian language)<br>
