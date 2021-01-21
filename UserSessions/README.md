<b>Here is code for User Login from Existing system</b>

<U>Legenda:</U>
User HAS NO access to DB.<BR> 
Application use only one secret user for  communication with DB.<BR>
<BR>
To identify windows user what works with DB and logging changes  this code is used.<BR>
Session - linked WindosUserName with PID in this way we know that User made changes.<BR>
Application creates 3 connection for each user<BR>
So 3 Sessions are created 1 main and 2 slave.<BR>


<b>Example:<BR>
-- Create "Main session" <BR>
	
<b>EXEC [dbo].[UserLogIn]    @WindowsUserName = 'User 1'</b> <BR>

-- This SP returns SessionId and Permission Matrix <BR>
-- Create 2 slave <br>
EXEC [dbo].[UserLogIn]    @WindowsUserName = 'User 1',    @MainSessionID = 130354
EXEC [dbo].[UserLogIn]    @WindowsUserName = 'User 1',    @MainSessionID = 130354

-- To close Sessions
EXEC [dbo].[CloseUserSession] @SessionID = 130354
 


<Tables:

--- USERS ---
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[Users]    Script Date: 21/01/2021 13:44:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Users](
	[UserID] [varchar](50) NOT NULL,
	[UserName] [varbinary](128) NULL,
	[UserEmail] [varbinary](128) NULL,
	[IsLocked] [bit] NOT NULL,
	[LanguageID] [char](1) NOT NULL,
	[Alias] [varchar](50) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsLocked]  DEFAULT ((0)) FOR [IsLocked]
GO

ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_LanguageID]  DEFAULT ([dbo].[GetDBDefaultLang]()) FOR [LanguageID]
GO


--- Users names from SAP ( this is the source )
/****** Object:  Table [SAP].[V_USR_NAME]    Script Date: 21/01/2021 13:43:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [SAP].[V_USR_NAME](
	[BNAME] [varchar](20) NOT NULL,
	[NAME_TEXT] [varchar](80) NOT NULL,
	[IsDeleted] [bit] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [SAP].[V_USR_NAME] ADD  CONSTRAINT [DF_V_USR_NAME_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

--- User premissions in application

/****** Object:  Table [dbo].[UsersPermissions]    Script Date: 21/01/2021 13:45:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UsersPermissions](
	[UserID] [VARCHAR](50) NOT NULL,
	[PermissionID] [INT] NOT NULL,
	[PermissionTypeID] [INT] NOT NULL,
 CONSTRAINT [PK_UsersPermissions] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[PermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UsersPermissions] ADD  CONSTRAINT [DF_UsersPermissions_PermissionTypeID]  DEFAULT ((0)) FOR [PermissionTypeID]
GO

ALTER TABLE [dbo].[UsersPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UsersPermissions_Permissions] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[PermissionsName] ([PermissionID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UsersPermissions] CHECK CONSTRAINT [FK_UsersPermissions_Permissions]
GO

ALTER TABLE [dbo].[UsersPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UsersPermissions_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UsersPermissions] CHECK CONSTRAINT [FK_UsersPermissions_Users]
GO
-- User Sessions--

/****** Object:  Table [dbo].[UsersSessions]    Script Date: 21/01/2021 13:46:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UsersSessions](
	[SessionID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](150) NULL,
	[SysUser] [varchar](150) NULL,
	[HostName] [nvarchar](128) NULL,
	[SessionStart] [datetime] NULL,
	[SessionEnd] [datetime] NULL,
	[ProcessID] [smallint] NULL,
	[AppName] [varchar](250) NULL,
	[IsBad] [bit] NOT NULL,
	[MainSessionID] [int] NULL,
 CONSTRAINT [PK_Sessions] PRIMARY KEY CLUSTERED 
(
	[SessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UsersSessions] ADD  CONSTRAINT [DF_Sessions_IsBad]  DEFAULT ((0)) FOR [IsBad]
GO

