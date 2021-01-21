
<b><u> Author:  Igor Nikiforov,  Montreal,  EMail: udfunctions@gmail.com   </b></u>
<br>
 AT()  Returns the beginning numeric position of the nth occurrence of a character expression within<br>
       another character expression, counting from the leftmost character<br>
 RAT() Returns the numeric position of the last (rightmost) occurrence of a character string within <br>
       another character string <br>
 OCCURS() Returns the number of times a character expression occurs within another character expression <br>
 PADL()   Returns a string from an expression, padded with spaces or characters to a specified length on the left side<br>
 PADR()   Returns a string from an expression, padded with spaces or characters to a specified length on the right side<br>
 PADC()   Returns a string from an expression, padded with spaces or characters to a specified length on the both sides<br>
 CHRTRAN()   Replaces each character in a character expression that matches a character in a second character expression<br>
             with the corresponding character in a third character expression.<br>
 STRTRAN()   Searches a character expression for occurrences of a second character expression,<br>
             and then replaces each occurrence with a third character expression.<br>
             Unlike a built-in function replace, STRTRAN has three additional parameters.<br>
 STRFILTER() Removes all characters from a string except those specified. <br>
 GETWORDCOUNT() Counts the words in a string<br>
 GETWORDNUM()   Returns a specified word from a string<br>
 GETALLWORDS()  Inserts the words from a string into the table<br>
 PROPER() Returns from a character expression a string capitalized as appropriate for proper names<br>
 RCHARINDEX()  Similar to the Transact-SQL function Charindex, with a Right search<br>
 ARABTOROMAN() Returns the character Roman numeral equivalent of a specified numeric expression (from 1 to 3999)<br>
 ROMANTOARAB() Returns the number equivalent of a specified character Roman numeral expression (from I to MMMCMXCIX)<br>
 Examples:  <br>
 <br>
 GETWORDCOUNT, GETWORDNUM<br>
 select  dbo.GETWORDCOUNT('User-Defined marvellous string Functions Transact-SQL', default)<br>
 select  dbo.GETWORDNUM('User-Defined marvellous string Functions Transact-SQL', 2, default)<br>
 Examples:  <br>
 CHRTRAN, STRFILTER<br>
 select dbo.CHRTRAN('ABCDEF', 'ACE', 'XYZ')   -- Displays XBYDZF<br>
 select dbo.STRFILTER('ABCDABCDABCD', 'AB')   -- Displays ABABAB<br>
 <br>
 AT, RAT, OCCURS, PROPER  <br>
 select  dbo.AT ('marvellous', 'User-Defined marvellous string Functions Transact-SQL', default)<br>
 select  dbo.OCCURS ('F', 'User-Defined marvellous string Functions Transact-SQL')<br>
 select  dbo.PROPER ('User-Defined marvellous string Functions Transact-SQL')<br>
 <br>
 PADC, PADR, PADL <br>
 select  dbo.PADC (' marvellous string Functions', 60, '+*+')<br>
 <br>
 ARABTOROMAN, ROMANTOARAB<br>
 select dbo.ARABTOROMAN(3888)      -- Displays MMMDCCCLXXXVIII<br>
 select dbo.ROMANTOARAB('CCXXXIV') -- Displays 234<br>
<br>
<br>
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
