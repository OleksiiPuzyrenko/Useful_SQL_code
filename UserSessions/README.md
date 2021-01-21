<b>Here is code for User Login from Existing system</b>

<U>Legenda:</U>
User HAS NO access to DB.<BR> 
Application use only one secret user for communication with DB.<BR>
<BR>
To identify windows user what works with DB and logging changes  this code is used.<BR>
SessionID links <Windos User Name> with PID and in this way we know that User change data.<BR>
To catch changes table's triggers are used

Application creates 3 connection for each user<BR>
So 3 Sessions are created 1 main and 2 slave.<BR>


<b>Example:<BR>
-- Create "Main session" <BR>
	
<b>EXEC [dbo].[UserLogIn]    @WindowsUserName = 'User 1'</b> <BR>

-- This SP returns SessionId and Permission Matrix <BR>
-- Create 2 slave <br>
EXEC [dbo].[UserLogIn]    @WindowsUserName = 'User 1',    @MainSessionID = 130354 <br>
EXEC [dbo].[UserLogIn]    @WindowsUserName = 'User 1',    @MainSessionID = 130354 <br>
<br>
-- To close Sessions <br>
EXEC [dbo].[CloseUserSession] @SessionID = 130354  


