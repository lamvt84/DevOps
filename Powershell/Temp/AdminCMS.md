# wUtility.AdminCMS

```sql
USE [master]
GO
/****** Object:  Database [wUtility.AdminCMS]    Script Date: 7/23/2020 3:10:45 PM ******/
CREATE DATABASE [wUtility.AdminCMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PayWallet.AdminDB', FILENAME = N'D:\Database\2019\Mobipay\wUtility.AdminCMS.mdf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 50MB )
 LOG ON 
( NAME = N'PayWallet.AdminDB_log', FILENAME = N'D:\Database\2019\Mobipay\wUtility.AdminCMS_log.ldf' , SIZE = 20MB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [wUtility.AdminCMS] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [wUtility.AdminCMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [wUtility.AdminCMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [wUtility.AdminCMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [wUtility.AdminCMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [wUtility.AdminCMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [wUtility.AdminCMS] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [wUtility.AdminCMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET RECOVERY FULL 
GO
ALTER DATABASE [wUtility.AdminCMS] SET  MULTI_USER 
GO
ALTER DATABASE [wUtility.AdminCMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [wUtility.AdminCMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [wUtility.AdminCMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [wUtility.AdminCMS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [wUtility.AdminCMS] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'wUtility.AdminCMS', N'ON'
GO
ALTER DATABASE [wUtility.AdminCMS] SET QUERY_STORE = OFF
GO
USE [wUtility.AdminCMS]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
--USE [wUtility.AdminCMS]
--GO
--/****** Object:  User [qa_ewallet]    Script Date: 7/23/2020 3:10:45 PM ******/
--CREATE USER [qa_ewallet] FOR LOGIN [qa_ewallet] WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [dev_ewallet]    Script Date: 7/23/2020 3:10:45 PM ******/
--CREATE USER [dev_ewallet] FOR LOGIN [dev_ewallet] WITH DEFAULT_SCHEMA=[dbo]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [qa_ewallet]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [dev_ewallet]
--GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetParentID]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<QuocPhong.Tran>
-- Create date: <07/31/2015>
-- Description:	<Lay FatherID theo FunctionID>
-- =============================================
CREATE FUNCTION [dbo].[FN_GetParentID]
(
	@_FunctionID int
)
RETURNS INT
AS

BEGIN
	DECLARE @_ParentID INT
	SELECT @_ParentID = ParentID FROM  dbo.Functions WHERE  FunctionID= @_FunctionID
	RETURN @_ParentID

END




GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetParentName]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<QuocPhong.Tran>
-- Create date: <07/31/2015>
-- Description:	<Lay Ten chuc nang cha theo @_FatherID>
-- =============================================
CREATE FUNCTION [dbo].[FN_GetParentName]
(
	-- Add the parameters for the function here
	@_ParentID int
)
RETURNS NVARCHAR(150)
AS
BEGIN
	DECLARE @_ParentName NVARCHAR(150)
	SELECT @_ParentName=[FunctionName] FROM dbo.Functions WHERE FunctionID=@_ParentID
	RETURN @_ParentName

END



GO
/****** Object:  UserDefinedFunction [dbo].[FN_Parameters_Split]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE FUNCTION [dbo].[FN_Parameters_Split]
    (@String NVARCHAR(MAX)
    ,@Delimiter NVARCHAR(10))
    
RETURNS @ValueTable TABLE ([Index] INT IDENTITY(1,1), [Value] NVARCHAR(1000))
BEGIN
    DECLARE @NextString NVARCHAR(MAX)
    DECLARE @Pos INT
   
    SET @String = @String + @Delimiter
	--Get position of first Comma
    SET @Pos = CHARINDEX(@Delimiter,@String)   
 
	--Loop while there is still a comma in the String of levels
    WHILE (@pos <> 0) 
        BEGIN
            SET @NextString = SUBSTRING(@String,1,@Pos - 1)
 
            INSERT  INTO @ValueTable
                    ([Value])
            VALUES  (LTRIM(RTRIM(@NextString)))
 
            SET @String = SUBSTRING(@String,@pos + 1,LEN(@String))  
            
            SET @pos = CHARINDEX(@Delimiter,@String)
        END
 
    RETURN
END





GO
/****** Object:  UserDefinedFunction [dbo].[FN_Split]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_Split] 
(
 @Keyword NVARCHAR(4000),
 @Delimiter NVARCHAR(255)
)
RETURNS @SplitKeyword TABLE (Keyword NVARCHAR(4000))
AS
BEGIN
 DECLARE @Word NVARCHAR(255)
 DECLARE @TempKeyword TABLE (Keyword NVARCHAR(4000))

 WHILE (CHARINDEX(@Delimiter, @Keyword, 1)>0)
 BEGIN
  SET @Word = SUBSTRING(@Keyword, 1 , CHARINDEX(@Delimiter, @Keyword, 1) - 1)
  SET @Keyword = SUBSTRING(@Keyword, CHARINDEX(@Delimiter, @Keyword, 1) + 1, LEN(@Keyword))
  INSERT INTO @TempKeyword VALUES(@Word)
 END
 
 INSERT INTO @TempKeyword VALUES(@Keyword)
 
 INSERT @SplitKeyword
 SELECT * FROM @TempKeyword
 RETURN
END









GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ErrorLogID] [int] IDENTITY(1,1) NOT NULL,
	[ErrorTime] [datetime] NOT NULL,
	[UserName] [nvarchar](128) NOT NULL,
	[HostName] [nvarchar](200) NULL,
	[ErrorNumber] [int] NOT NULL,
	[ErrorCode] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorProcedure] [nvarchar](126) NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [nvarchar](4000) NOT NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED 
(
	[ErrorLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Functions]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Functions](
	[FunctionID] [int] IDENTITY(1,1) NOT NULL,
	[FunctionName] [nvarchar](150) NOT NULL,
	[Url] [nvarchar](150) NOT NULL,
	[IsDisplay] [bit] NULL,
	[IsActive] [bit] NULL,
	[CreatedTime] [datetime] NULL,
	[ParentID] [int] NULL,
	[Order] [int] NULL,
	[CssIcon] [nvarchar](50) NULL,
	[ActionName] [varchar](100) NULL,
	[SystemID] [int] NOT NULL,
 CONSTRAINT [PK_Functions] PRIMARY KEY CLUSTERED 
(
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GroupFunctions]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupFunctions](
	[GroupID] [int] NOT NULL,
	[FunctionID] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[IsInsert] [bit] NULL,
	[IsUpdate] [bit] NULL,
	[IsDelete] [bit] NULL,
	[IsGrant] [bit] NULL,
 CONSTRAINT [PK_GroupFunctions] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC,
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[GroupID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Alias] [nvarchar](150) NULL,
	[IsActive] [bit] NOT NULL,
	[SystemID] [int] NOT NULL,
 CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[System]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[System](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedUser] [varchar](50) NULL,
 CONSTRAINT [PK_System] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[Password] [varchar](50) NULL,
	[FullName] [nvarchar](150) NULL,
	[Email] [varchar](150) NULL,
	[Status] [bit] NULL,
	[CreatedUser] [varchar](50) NULL,
	[CreatedTime] [datetime] NULL,
	[IsAdministrator] [bit] NULL,
	[Mobile] [varchar](20) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserFunction]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserFunction](
	[UserID] [int] NOT NULL,
	[FunctionID] [int] NOT NULL,
	[IsGrant] [bit] NOT NULL,
	[IsInsert] [bit] NOT NULL,
	[IsUpdate] [bit] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[CreatedUserID] [int] NOT NULL,
 CONSTRAINT [PK_UserFunction] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserFunction_Log]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserFunction_Log](
	[UserID] [int] NOT NULL,
	[FunctionID] [int] NOT NULL,
	[IsGrant] [bit] NOT NULL,
	[IsInsert] [bit] NOT NULL,
	[IsUpdate] [bit] NOT NULL,
	[IsDelete] [bit] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[CreatedUserID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserGroups]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGroups](
	[GroupID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[CreatedUser] [varchar](50) NULL,
 CONSTRAINT [PK_UserGroups] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLogs]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLogs](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[FunctionID] [int] NOT NULL,
	[Username] [varchar](50) NULL,
	[Fullname] [nvarchar](100) NULL,
	[FunctionName] [nvarchar](100) NULL,
	[CreatedTime] [datetime] NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[LogType] [int] NULL,
	[ClientIP] [varchar](20) NULL,
 CONSTRAINT [PK_UserLogs] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSystem]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSystem](
	[UserID] [int] NOT NULL,
	[SystemID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedUser] [varchar](50) NULL,
	[IsMod] [bit] NOT NULL,
 CONSTRAINT [PK_UserSystem] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[SystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [NcIdx_UserID_Func_Time]    Script Date: 7/23/2020 3:10:45 PM ******/
CREATE NONCLUSTERED INDEX [NcIdx_UserID_Func_Time] ON [dbo].[UserLogs]
(
	[LogType] ASC,
	[UserID] ASC,
	[FunctionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Functions] ADD  CONSTRAINT [DF_Functions_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Functions] ADD  CONSTRAINT [DF_Functions_SystemID]  DEFAULT ((0)) FOR [SystemID]
GO
ALTER TABLE [dbo].[GroupFunctions] ADD  CONSTRAINT [DF_GroupFunctions_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Groups] ADD  CONSTRAINT [DF_Groups_SystemID]  DEFAULT ((0)) FOR [SystemID]
GO
ALTER TABLE [dbo].[System] ADD  CONSTRAINT [DF_System_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_CreatedDate]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[UserGroups] ADD  CONSTRAINT [DF_UserGroups_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[UserLogs] ADD  CONSTRAINT [DF_UserLogs_LogTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[UserLogs] ADD  CONSTRAINT [DF_UserLogs_LogType]  DEFAULT ((0)) FOR [LogType]
GO
ALTER TABLE [dbo].[UserSystem] ADD  CONSTRAINT [DF_UserSystem_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[UserSystem] ADD  CONSTRAINT [DF_UserSystem_IsMod]  DEFAULT ((0)) FOR [IsMod]
GO
ALTER TABLE [dbo].[GroupFunctions]  WITH CHECK ADD  CONSTRAINT [FK_GroupFunctions_Functions] FOREIGN KEY([FunctionID])
REFERENCES [dbo].[Functions] ([FunctionID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GroupFunctions] CHECK CONSTRAINT [FK_GroupFunctions_Functions]
GO
ALTER TABLE [dbo].[GroupFunctions]  WITH CHECK ADD  CONSTRAINT [FK_GroupFunctions_Groups] FOREIGN KEY([GroupID])
REFERENCES [dbo].[Groups] ([GroupID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GroupFunctions] CHECK CONSTRAINT [FK_GroupFunctions_Groups]
GO
ALTER TABLE [dbo].[UserLogs]  WITH CHECK ADD  CONSTRAINT [FK_UserLogs_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UserLogs] CHECK CONSTRAINT [FK_UserLogs_Users]
GO
/****** Object:  StoredProcedure [dbo].[SP_CheckPermission]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		phongtq
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_CheckPermission]
	@_UserID int,
	@_ActionName varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @_FunctionID INT = -1, 
			@_FunctionName Nvarchar(100) = ''
	SET @_ActionName = ISNULL(@_ActionName,'')
	select @_FunctionID = FunctionID ,
		@_FunctionName = Functionname
	From dbo.Functions
	Where ActionName = @_ActionName

	SET @_FunctionID = ISNULL(@_FunctionID ,-1)

	SELECT UserID, FunctionID, @_FunctionName FunctionName, @_ActionName ActionName, IsGrant, IsInsert, IsUpdate, IsDelete 
	FROM dbo.UserFunction
	WHERE FunctionID=@_FunctionID and UserID=@_UserID
	
    -- Insert statements for procedure here
END




GO
/****** Object:  StoredProcedure [dbo].[SP_ErrorLog_Delete]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ErrorLog_Delete]
	 @FromDate DateTime =null
	,@ToDate DateTime =null
	,@ErrorCode	int OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM ErrorLog 
		WHERE 
			(@FromDate IS NULL OR ErrorTime>=@FromDate )
			AND
			(@ToDate IS NULL OR ErrorTime <= @ToDate)
		SET @ErrorCode = 0
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @ErrorCode = -99;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError] 
						@ErrorCode = @ErrorCode OUTPUT
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH
END






GO
/****** Object:  StoredProcedure [dbo].[SP_ErrorLog_GetPage]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_ErrorLog_GetPage]
	-- ADD THE PARAMETERS FOR THE STORED PROCEDURE HERE
		 @FromDate DATETIME =NULL
		,@ToDate DATETIME =NULL
		,@PageNumber INT
		,@PaSize INT
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @CONDITION NVARCHAR(MAX)
	DECLARE @START INT, @END INT
	BEGIN TRANSACTION GETDATASET
		SET @CONDITION=''
		SET @SQL=''
		SET @START = (((@PageNumber - 1) * @PaSize) + 1)
		SET @END = (@START + @PaSize - 1)
		SET @SQL = ' DECLARE  @TEMPORARYTABLE TABLE (
			ID INT IDENTITY(1,1) PRIMARY KEY,
			[ErrorLogID] INT,
			[ErrorTime] DATETIME,
			[UserName] NVARCHAR(50),
			[HostName] NVARCHAR (100),
			[ErrorNumber] INT,
			[ErrorCode] INT,
			[ErrorSeverity] INT ,
			[ErrorState] INT,
			[ErrorProcedure] NVARCHAR (100),
			[ErrorLine] INT,
			[ErrorMessage] NVARCHAR(1000) )		
			DECLARE @COUNTER INT'
		SET @SQL=@SQL+' INSERT INTO @TEMPORARYTABLE
						SELECT ErrorLogID
							  ,ErrorTime
							  ,UserName
							  ,HostName
							  ,ErrorNumber
							  ,ErrorCode
							  ,ErrorSeverity
							  ,ErrorState
							  ,ErrorProcedure
							  ,ErrorLine
							  ,	ErrorMessage			 
						FROM ErrorLog WHERE ERRORLOGID >= 0 '
		IF(@FROMDATE IS NOT NULL)
					SET @CONDITION=@CONDITION +' AND ErrorTime>= '''  +   CONVERT(NVARCHAR,  @FROMDATE, 0)  + '''' 
		           			 
				IF(@TODATE IS NOT NULL)
					SET @CONDITION=@CONDITION +' AND  ErrorTime<= '''  +   CONVERT(NVARCHAR,  @TODATE, 0)  + '''' 
					
				SET @CONDITION=@CONDITION + 'ORDER BY ErrorLogID DESC'
		
		SET @SQL=@SQL+@CONDITION
		SET @SQL= @SQL +' SELECT @COUNTER = COUNT(*) FROM @TEMPORARYTABLE  	
						  SELECT TOP ('+CAST(@PaSize AS VARCHAR(10)) +') 
							  ErrorLogID
							  ,ErrorTime
							  ,UserName
							  ,HostName
							  ,ErrorNumber
							  ,ErrorCode
							  ,ErrorSeverity
							  ,ErrorState
							  ,ErrorProcedure
							  ,ErrorLine
							  ,ErrorMessage
							  ,@COUNTER AS Counter
						  FROM @TEMPORARYTABLE
						  WHERE (ID >='+CAST(@START AS VARCHAR(10))+') AND (ID <= '+CAST(@END AS VARCHAR(10))+')
						  DELETE FROM @TEMPORARYTABLE'
			--PRINT (@SQL)
			EXEC SP_EXECUTESQL @SQL
			IF @@ERROR <> 0
				GOTO ERRORHANDLER	
			COMMIT TRANSACTION GETDATASET
		RETURN 0
		ERRORHANDLER:
		ROLLBACK TRANSACTION GETDATASET
	RETURN @@ERROR
END



	--SELECT * FROM ERRORLOG 
	--WHERE (@FROMDATE IS NULL OR ERRORTIME>=@FROMDATE )AND(@TODATE IS NULL OR ERRORTIME <= @TODATE)
	--ORDER BY ERRORTIME ASC
	--END








GO
/****** Object:  StoredProcedure [dbo].[SP_Function_GetByUserID]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		phongtq
-- Create date:	<30/10/2015>
-- Description: Lay danh sach function theo user de build menu
-- =============================================
CREATE PROCEDURE [dbo].[SP_Function_GetByUserID]
	@_UserID INT,
	@_GetGrant INT = NULL,
	@_SystemID VARCHAR(100) = ''
AS
BEGIN	
	SET NOCOUNT ON;  
	-- lay distinct danh sach functionID ma user dc phan quyen	
	DECLARE @tblFunctionID TABLE(FunctionID INT)
	INSERT INTO @tblFunctionID(FunctionID)
	SELECT FunctionID FROM dbo.UserFunction
	WHERE UserID = @_UserID AND (ISNULL(@_GetGrant, -1) = -1 OR IsGrant = ISNULL(@_GetGrant, -1))
	
	DECLARE @tblParentFunctionID TABLE(ParentID INT)
	DECLARE @Count INT;
	-- lay parentID theo functionID
	INSERT INTO  @tblParentFunctionID(ParentID)
	SELECT f.ParentID FROM dbo.Functions f INNER JOIN @tblFunctionID tbl ON tbl.FunctionID = f.FunctionID
	WHERE f.ParentID > 0
	GROUP BY f.ParentID
	SET @Count = @@ROWCOUNT

	WHILE @Count > 0
	BEGIN
		
		DECLARE @tblParentID TABLE(ParentID INT)		
		DECLARE @Loop TINYINT, @LoopLimit TINYINT = 0;		
		
		DELETE TOP(1) FROM @tblParentFunctionID 
		OUTPUT Deleted.ParentID INTO @tblParentID
		SET @Loop = @@ROWCOUNT;		

		WHILE @Loop > 0
		BEGIN
			DECLARE @FunctionID INT, @ParentID INT
			SELECT @FunctionID = ParentID FROM @tblParentID
			IF NOT EXISTS(SELECT FunctionID FROM @tblFunctionID WHERE FunctionID = @FunctionID)	
			BEGIN	
				INSERT INTO @tblFunctionID(FunctionID) VALUES(@FunctionID)
			END
			SELECT  @ParentID = ParentID FROM dbo.Functions WHERE FunctionID = @FunctionID
			DELETE FROM @tblParentID WHERE ParentID = @FunctionID
			IF(@ParentID > 0)
			BEGIN				
				INSERT INTO @tblParentID( ParentID )
				VALUES ( @ParentID )
				SET @Loop = @@ROWCOUNT;		
			END	
			ELSE 
				SET @Loop = 0;
			--check lap vo han, do thiet lap parentid bi loi
			SET @LoopLimit = @LoopLimit + 1	
			if	@LoopLimit > 100 BREAK;	-- ko the loop den hon 100 cap
			--end lap vo han					
		END	
		SET @Count = @Count - 1	
	END

	SELECT f.* FROM dbo.Functions f 
	INNER JOIN @tblFunctionID tbl ON tbl.FunctionID = f.FunctionID
	WHERE (ISNULL(@_SystemID,'') = '' OR f.SystemID in (SELECT value FROM [dbo].FN_Parameters_Split(@_SystemID, ',')))
	ORDER BY f.ParentID
END



GO
/****** Object:  StoredProcedure [dbo].[SP_Functions_Delete]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran: DungTD Modified 30/10/2015
-- Create date:	<07/16/2015>
-- Description: Xóa chức năng (functionID)
-- =============================================
CREATE PROCEDURE [dbo].[SP_Functions_Delete]
	@_FunctionID	int
   ,@_ResponseCode int output
AS
BEGIN
   SET NOCOUNT, XACT_ABORT ON;
   DECLARE @_ERR_FUNCTION_INACTIVE INT = -24,
			@_ERR_FUNCTION_NOT_EXIST INT = -25,
			@_IsActive INT = 0,
			@_ERR_UNKNOWN INT = -99,
			@_FunctionID_In INT
	SELECT @_FunctionID_In = FunctionID,
			@_IsActive = IsActive
	FROM Functions
	WHERE FunctionID = @_FunctionID

	SET @_FunctionID_In = ISNULL(@_FunctionID_In, 0)
	IF (@_FunctionID_In = 0)
	BEGIN
		SET @_ResponseCode = @_ERR_FUNCTION_NOT_EXIST
		RETURN;
	END

	IF(@_IsActive <> 0)
	BEGIN
		SET @_ResponseCode = @_ERR_FUNCTION_INACTIVE
		RETURN;
	END
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM [dbo].[UserFunction]
		OUTPUT Deleted.* INTO [dbo].[UserFunction_Log]
		WHERE [FunctionID] = @_FunctionID

		DELETE FROM [dbo].[UserFunction] WHERE FunctionID = @_FunctionID
		DELETE FROM Functions  WHERE [FunctionID]  = @_FunctionID 
		SET @_ResponseCode = 1
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = @_ERR_UNKNOWN;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;			
	END CATCH; 
END




GO
/****** Object:  StoredProcedure [dbo].[SP_Functions_GetPage]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Functions_GetPage]
	@_Keyword NVARCHAR(150) = ''
	,@_ParentID	int = -1
	,@_SystemID	int = -1
	,@_Status INT 	
	,@_CurrPage INT
	,@_RecordPerPage INT
	,@_TotalRecord INT OUT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @_Start INT = (((@_CurrPage-1) * @_RecordPerPage)+1)
	DECLARE @_End INT =   @_Start + @_RecordPerPage-1

	SELECT TMP.* INTO #tmp_fn_lst
	  FROM (
		SELECT ROW_NUMBER() OVER(ORDER BY FunctionID DESC) AS STT,
		 * ,[dbo].[FN_GetParentName](ParentID) as ParentName
		FROM [dbo].[Functions]
		WHERE (ISNULL(@_SystemID,-1) <= -1 OR [SystemID] = @_SystemID)
			AND (ISNULL(@_ParentID,-1) <= -1 OR [ParentID] = @_ParentID)
			AND (ISNULL(@_Status,-1) = -1 OR [IsActive] = @_Status)
			AND (ISNULL(@_KeyWord, '') = '' OR ([FunctionName] LIKE '%' + @_KeyWord + '%')) 
	) AS TMP 
	
	SELECT * FROM #tmp_fn_lst
	WHERE STT BETWEEN @_Start AND @_End

	SELECT @_TotalRecord = (SELECT COUNT(FunctionID) FROM #tmp_fn_lst) 
END



GO
/****** Object:  StoredProcedure [dbo].[SP_Functions_SelectByCondition]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date:	<07/16/2015>
-- Description: Lấy danh sacá chức năng 
-- =============================================
CREATE PROCEDURE [dbo].[SP_Functions_SelectByCondition]
	@_ParentID	int = -1
	,@_FunctionID INT = 0
	,@_FunctionName nvarchar(50) = ''
	,@_ActionName	varchar(100) = ''
	,@_IsActive	int = -1
	,@_IsDisplay	int = -1
	,@_SystemID VARCHAR(100) = ''
AS
BEGIN
    SET NOCOUNT ON
	SELECT *, dbo.FN_GetParentName(ParentID) AS ParentName FROM Functions
	WHERE (ISNULL(@_ParentID,-1) <= -1 OR [ParentID] = @_ParentID)
		AND (ISNULL(@_FunctionID,-1) <= -1 OR [FunctionID] = @_FunctionID)
		AND (ISNULL(@_IsActive,-1) <= -1 OR [IsActive] = @_IsActive)
		AND (ISNULL(@_IsDisplay,-1) <= -1 OR [IsDisplay] = @_IsDisplay)
		AND (ISNULL(@_SystemID,'') = '' OR SystemID in (SELECT value FROM [dbo].FN_Parameters_Split(@_SystemID, ',')))
		AND (ISNULL(@_ActionName,'') = '' OR ActionName = @_ActionName)
		AND (ISNULL(@_FunctionName,'')='' OR [FunctionName] like N'%'+@_FunctionName+'%')
	ORder by [Order]
END





GO
/****** Object:  StoredProcedure [dbo].[SP_Functions_Update]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		quocphong.tran
-- Create date:	<07/16/2015>
-- Description: cập nhật chức năng (functionID) = 0:insert, > 0 update
-- =============================================
CREATE PROCEDURE [dbo].[SP_Functions_Update]
	 @_FunctionID	int 
	,@_FunctionName	nvarchar(150) = ''
	,@_ActionName varchar(100) = ''
	,@_Url	nvarchar(100) = ''	
	,@_IsDisplay bit = NULL
	,@_IsActive	bit = NULL
	,@_ParentID	int = -1
	,@_Order int = null
	,@_CssIcon nvarchar(50) = ''
	,@_SystemID int = -1
	,@_ResponseCode int output
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;
	DECLARE @_ERR_EXISTS_FUNCTION_NAME INT = -70,
			@_ERR_EXISTS_URL INT = -71,
			@_ERR_EXISTS_URL_DISPLAY INT = -72,
			@_ERR_NOTEXISTS_FUNCTION INT = -73,
			@_ERR_UNKNOW INT = -99
    --Check các DK đã tồn tại trong hệ thống nếu có trả về mã lỗi.
    -- Ton tai ten
		--IF (EXISTS (SELECT * FROM Functions WHERE FunctionName=@_FunctionName AND FunctionID <> @_FunctionID ) )
		--	BEGIN
		--		SET @_ResponseCode = @_ERR_EXISTS_FUNCTION_NAME
		--		RETURN
		--	END
		--IF (@_Url <> '' AND (EXISTS (SELECT * FROM Functions WHERE Url=@_Url AND FunctionID <> @_FunctionID ) ) )
		--	BEGIN
		--		SET @_ResponseCode = @_ERR_EXISTS_URL
		--		RETURN
		--	END
		
	BEGIN TRANSACTION
	BEGIN TRY		
		IF (@_FunctionID = 0) --Insert
			BEGIN
				SELECT @_Order=ISNULL(MAX([Order]),0)+1 FROM [Functions] WHERE [ParentID]=@_ParentID
				INSERT INTO [Functions]
					   ([FunctionName]
					   ,[Url]					  
					   ,[IsDisplay]		
					   ,[IsActive]
					   ,[CreatedTime] 
					   ,[ParentID]
					   ,[Order]					  
					   ,[CssIcon]
					   ,[ActionName]
					   ,SystemID) 
					   
				 VALUES
					   (@_FunctionName 
					   ,@_Url					   
					   ,@_IsDisplay 
					   ,@_IsActive
					   ,GETDATE() 
					   ,@_ParentID
	 				   ,@_Order	 				 
					   ,@_CssIcon
					   ,@_ActionName
					   ,ISNULL(@_SystemID,0))
				SET @_ResponseCode = @@IDENTITY
			END
		ELSE
			IF(EXISTS(SELECT*FROM Functions WHERE  FunctionID = @_FunctionID ))
			BEGIN
				UPDATE [dbo].[Functions]
				   SET [FunctionName]  = CASE WHEN ISNULL(@_FunctionName,'') = '' THEN FunctionName ELSE @_FunctionName END
					  ,[Url] = CASE WHEN ISNULL(@_Url,'') = '' THEN [Url] ELSE @_Url END	  
					  ,[IsDisplay] = CASE WHEN @_IsDisplay IS NULL THEN [IsDisplay] ELSE @_IsDisplay END
					  ,[IsActive] = CASE WHEN @_IsActive IS NULL THEN [IsActive] ELSE @_IsActive END
					  ,[ParentID] = CASE WHEN ISNULL(@_ParentID,-1) = -1 THEN [ParentID] ELSE @_ParentID END
					  ,[Order] = CASE WHEN @_Order IS NULL THEN [Order] ELSE @_Order END
					  ,[CssIcon] = CASE WHEN ISNULL(@_CssIcon,'') = '' THEN [CssIcon] ELSE @_CssIcon END
					  ,[ActionName] = CASE WHEN ISNULL(@_ActionName,'') = '' THEN [ActionName] ELSE @_ActionName END
					  ,[SystemID] = CASE WHEN ISNULL(@_SystemID,-1) = -1 THEN [SystemID] ELSE @_SystemID END
					WHERE [FunctionID] = @_FunctionID 
				SET @_ResponseCode = @_FunctionID			
			END
			ELSE BEGIN
				SET @_ResponseCode = @_ERR_NOTEXISTS_FUNCTION;
				END
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = @_ERR_UNKNOW;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
						@ErrorCode = @_ResponseCode OUTPUT
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH
END	




GO
/****** Object:  StoredProcedure [dbo].[SP_Functions_UpdateOrder]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		quocphong.tran
-- Create date:	<07/16/2015>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Functions_UpdateOrder]
	 @_FunctionID	int 
	,@_ParentID	INT = null
	,@_Order int = null
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;
	
	BEGIN TRANSACTION
	BEGIN TRY		
		
		IF(EXISTS(SELECT 1 FROM Functions WHERE  FunctionID = @_FunctionID ))
		BEGIN
			UPDATE [dbo].[Functions]
				SET [ParentID] = ISNULL(@_ParentID,ParentID)
					,[Order] = ISNULL(@_Order,[Order])
				WHERE [FunctionID] = @_FunctionID 
		END
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
		-- Insert Log
		EXEC	[dbo].[SP_LogError]
	END CATCH
END	




GO
/****** Object:  StoredProcedure [dbo].[SP_Group_Delete]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Group_Delete]
	 @_GroupID int
	,@_ResponseStatus	int output
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOTEXIST_GROUP INT = -1,
			@_ERR_EXISTS_GROUP INT = -2,
			@_ERR_UNKNOW INT = -99,
			@_RETURN_SUCCESS INT = 1
	BEGIN TRANSACTION
	BEGIN TRY
		IF (EXISTS(SELECT 1 FROM [Groups] WHERE GroupID = @_GroupID))
			BEGIN
				DELETE FROM [dbo].[GroupFunctions] WHERE GroupID = @_GroupID
				DELETE FROM [dbo].[Groups] WHERE [GroupID] = @_GroupID
				SET @_ResponseStatus = @_RETURN_SUCCESS;
			END
		ELSE
			BEGIN
				SET @_ResponseStatus = @_ERR_NOTEXIST_GROUP;
			END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = @_ERR_UNKNOW;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Group_GetByCondition]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Group_GetByCondition]
	@_GroupID INT = 0
	,@_Name nvarchar(50)= ''
	,@_IsActive bit=null
	,@_SystemtID int = -1
AS
BEGIN
	SET NOCOUNT ON;

	SELECT *
	FROM dbo.[Groups] 
	WHERE (ISNULL(@_SystemtID, -1) = -1 OR SystemID = @_SystemtID)
		AND (ISNULL(@_GroupID, 0) = 0 OR GroupID = @_GroupID)
		AND (ISNULL(@_Name,'') = '' OR Name = @_Name )
		AND (@_IsActive IS NULL OR IsActive = @_IsActive)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Group_InsertUpdate]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		phongtq
-- Create date: 24/01/2018
-- Description:	thêm/sửa nhóm người dùng
-- =============================================
CREATE PROCEDURE [dbo].[SP_Group_InsertUpdate]
	 @_GroupID	int 
	,@_Name	nvarchar(50)
	,@_Alias	nvarchar(50) = ''
	,@_IsActive	bit = NULL
	,@_SystemID int
	,@_ResponseStatus int output
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOTEXIST_GROUP INT = -1,
			@_ERR_EXISTS_GROUP INT = -2,
			@_ERR_UNKNOW INT = -99,
			@_ERR_DATA_INVALID INT = -600
	SET @_ResponseStatus = @_ERR_UNKNOW

	BEGIN TRANSACTION
	BEGIN TRY
	--thêm mới
		IF (ISNULL(@_GroupID, 0) = 0)
			BEGIN
				IF(ISNULL(@_Name,'') = '')
				BEGIN 
					SET @_ResponseStatus = @_ERR_DATA_INVALID;
					RETURN;
				END
				IF (NOT EXISTS (SELECT 1 FROM Groups WHERE [Name] = @_Name))
					BEGIN 
						INSERT INTO [dbo].[Groups]
							   ([Name]
							   ,[Alias]
							   ,[IsActive]
							   ,[SystemID])
						 VALUES
							   (@_Name
							   ,@_Alias
							   ,@_IsActive
							   ,ISNULL(@_SystemID,0))
						SET @_ResponseStatus = @@IDENTITY
					END
				ELSE
					BEGIN
						SET @_ResponseStatus= @_ERR_EXISTS_GROUP;
						RETURN;
					END
			END
		ELSE --Sửa
			BEGIN
				IF (EXISTS (SELECT 1 FROM Groups WHERE [Name]= @_Name AND GroupID<>@_GroupID))
					BEGIN
						SET @_ResponseStatus= @_ERR_EXISTS_GROUP
					END
				ELSE					
					BEGIN
						UPDATE [dbo].[Groups]
						SET  [Name] = CASE WHEN ISNULL(@_Name,'') = '' THEN [Name] ELSE @_Name END
							,[Alias] = CASE WHEN ISNULL(@_Alias,'') = '' THEN [Alias] ELSE @_Alias END
							,[IsActive] = CASE WHEN @_Alias IS NULL THEN [IsActive] ELSE @_IsActive END
							,[SystemID] = CASE WHEN ISNULL(@_SystemID,-1) < -1 THEN [SystemID] ELSE @_SystemID END
						WHERE [GroupID] = @_GroupID
						SET @_ResponseStatus = @_GroupID
					END
			END
			COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = @_ERR_UNKNOW;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
						@ErrorCode = @_ResponseStatus OUTPUT
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GroupFunction_DeleteAllByGroupID]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
CREATE PROCEDURE [dbo].[SP_GroupFunction_DeleteAllByGroupID]
	 @_GroupID int
	,@_ResponseCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM [dbo].[GroupFunctions]
		WHERE GroupID = @_GroupID 

		IF(@_ResponseCode < 0) 
		BEGIN
			ROLLBACK TRANSACTION;
			RETURN;
		END

		SET @_ResponseCode = 1
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = -99;
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;		
		EXEC	[dbo].[sp_LogError]							
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[SP_GroupFunction_DeleteList]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
CREATE PROCEDURE [dbo].[SP_GroupFunction_DeleteList]
	 @_GroupID int
	,@_FunctionID NVARCHAR(4000)
	,@_ResponseCode	int output
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		
		DELETE FROM [dbo].[GroupFunctions]
		WHERE [GroupID] = @_GroupID AND 
		FunctionID IN (SELECT Cast(Value as INT) FROM dbo.FN_Parameters_Split(@_FunctionID, ','))

		IF(@_ResponseCode < 0) 
		BEGIN
			ROLLBACK TRANSACTION;
			RETURN;
		END

		SET @_ResponseCode = 1
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = -99;
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;		
		EXEC	[dbo].[sp_LogError]							
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GroupFunction_GetByGroupID]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
CREATE PROCEDURE [dbo].[SP_GroupFunction_GetByGroupID]
	@_GroupID int
AS
BEGIN	
	SET NOCOUNT ON;  
	SELECT  uf.*, f.ActionName,
	[dbo].[FN_GetParentID](uf.[FunctionID]) AS ParentID,
	[dbo].[FN_GetParentName]([dbo].[FN_GetParentID](uf.[FunctionID])) AS ParentName 
	FROM dbo.GroupFunctions uf
	Inner Join dbo.Functions f
	ON uf.FunctionID = f.FunctionID
	WHERE uf.GroupID = @_GroupID ORDER BY ParentID ASC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GroupFunction_Insert]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
CREATE PROCEDURE [dbo].[SP_GroupFunction_Insert]
	 @_GroupID  INT
	,@_PermissionOfFnIDs NVARCHAR(MAX)	--FunctionID,IsGrant,IsInsert,IsUpdate,IsDelete;...
	,@_ResponseCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOT_EXIST_GROUP INT = -50
	DECLARE @_ERR_UNKNOWN INT = -99
	IF NOT EXISTS (SELECT GroupID FROM [dbo].[Groups] WHERE GroupID = @_GroupID)
    BEGIN
		SET @_ResponseCode = @_ERR_NOT_EXIST_GROUP
		RETURN
    END
	IF(ISNULL(@_PermissionOfFnIDs,'') = '')
	BEGIN
		SET @_ResponseCode = -600
		RETURN
    END
	BEGIN TRANSACTION
	BEGIN TRY
			
			DECLARE @tblFunctionID TABLE(FunctionID INT, IsGrant BIT, IsInsert BIT, IsUpdate BIT, IsDelete BIT)
			INSERT INTO @tblFunctionID(FunctionID, IsGrant, IsInsert, IsUpdate, IsDelete)	
			EXEC SP_SplitToTableWithMultiColumn @Split = @_PermissionOfFnIDs, @Delimiter1 = ';', @Delimiter2 = ','	

			DELETE FROM dbo.GroupFunctions
				WHERE GroupID = @_GroupID

			DECLARE	@Now DATETIME = GETDATE();								
			INSERT INTO [dbo].[GroupFunctions]
			(
			    [GroupID],
			    [FunctionID],
				[IsGrant],
			    [IsInsert],
			    [IsUpdate],
			    [IsDelete],
			    [CreatedTime]
			)
			SELECT DISTINCT @_GroupID, FunctionID, IsGrant, IsInsert, IsUpdate, IsDelete, @Now
			FROM @tblFunctionID
		
		 SET @_ResponseCode = 1;
		 COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		SET @_ResponseCode = @_ERR_UNKNOWN;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;			
		EXEC	[dbo].[sp_LogError]			
			
	END CATCH; 
END


GO
/****** Object:  StoredProcedure [dbo].[SP_LogError]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 01/05/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LogError] 
    @ErrorCode int = 0 OUTPUT 
AS                               
BEGIN
   SET NOCOUNT ON;
   SET @ErrorCode = 0;

   BEGIN TRY
		IF ERROR_NUMBER() IS NULL   RETURN;
		IF XACT_STATE() = -1
			BEGIN
				PRINT 'Cannot log error since the current transaction is in an uncommittable state. ' 
				+ 'Rollback the transaction before executing SP_LogError in order to successfully log error information.';
				RETURN;
			END
		SET @ErrorCode = ERROR_NUMBER();
		IF @ErrorCode > 0 SET @ErrorCode = 0 - @ErrorCode;

		INSERT INTO [dbo].[ErrorLog]
				   ([ErrorTime]
				   ,[UserName]
				   ,[HostName]
				   ,[ErrorNumber]
				   ,[ErrorCode]
				   ,[ErrorSeverity]
				   ,[ErrorState]
				   ,[ErrorProcedure]
				   ,[ErrorLine]
				   ,[ErrorMessage])
			 VALUES
				   (GETDATE()
				   ,CONVERT(sysname, CURRENT_USER)
				   ,HOST_NAME()
				   ,ERROR_NUMBER()
				   ,@ErrorCode
				   ,ERROR_SEVERITY()
				   ,ERROR_STATE()
				   ,ERROR_PROCEDURE()
				   ,ERROR_LINE()
				   ,ERROR_MESSAGE())
	END TRY
	BEGIN CATCH
		PRINT 'An error occurred in stored procedure SP_LogError: ';
		EXECUTE [dbo].[SP_LogErrorPrint];
		RETURN -1;
	END CATCH
END;






GO
/****** Object:  StoredProcedure [dbo].[SP_LogErrorPrint]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP_PrintError prints error information about the error that caused 
-- execution to jump to the CATCH block of a TRY...CATCH construct. 
-- Should be executed from within the scope of a CATCH block otherwise 
-- it will return without printing any error information.
CREATE PROCEDURE    [dbo].[SP_LogErrorPrint] 
AS
BEGIN
    SET NOCOUNT ON;

    -- Print error information. 
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', State ' + CONVERT(varchar(5), ERROR_STATE()) + 
          ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') + 
          ', Line ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END;






GO
/****** Object:  StoredProcedure [dbo].[SP_SplitToTableWithMultiColumn]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		DungTD
-- Create date:	<04/11/2015>
-- Description: Cat chuoi thanh bang voi nhieu column
-- =============================================
CREATE PROC [dbo].[SP_SplitToTableWithMultiColumn] 
(
	@Split NVARCHAR(max),
	@Delimiter1 VARCHAR(1),
	@Delimiter2 VARCHAR(1)
)
as
SET @Split = RTRIM(LTRIM(@Split));

DECLARE @count INT
DECLARE @tblSplit TABLE(ID INT, Value NVARCHAR(500))
DECLARE @spl NVARCHAR(MAX) = '';

INSERT INTO @tblSplit ( ID, Value )
SELECT [Index], [Value] FROM [dbo].[FN_Parameters_Split](@Split, @Delimiter1)
SET @count = @@ROWCOUNT

WHILE @count > 0
BEGIN
	DECLARE @Value NVARCHAR(500), @ID INT
	SELECT TOP 1 @ID = ID, @Value = Value FROM @tblSplit
	IF @count > 1
		SET @spl = @spl + 'SELECT ' + '''' + REPLACE(@Value, @Delimiter2, '''' + @Delimiter2 + '''') + '''' + ' UNION ALL '
	ELSE
		SET @spl = @spl + 'SELECT ' + '''' + REPLACE(@Value, @Delimiter2, '''' + @Delimiter2 + '''') + ''''
	DELETE FROM @tblSplit WHERE ID = @ID
	SET @count = @count - 1
END

EXEC sp_executesql @spl






GO
/****** Object:  StoredProcedure [dbo].[SP_System_GetList]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_System_GetList]
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;

	SELECT *
	FROM [dbo].[System]
END






GO
/****** Object:  StoredProcedure [dbo].[SP_User_Authenticate]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_User_Authenticate]
	@_Username VARCHAR(50) = '',
	@_Email VARCHAR(150) = '', --trg hop authen gmail
	@_Password VARCHAR(50),
	@_ClientIP VARCHAR(20) = NULL,
	@_SystemID INT = 0,
	@_ResponseStatus INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @_ERR_INVALID_PASSWORD INT = -53;
	DECLARE @_ERR_NOT_EXIST_ACCOUNT INT = -50;
	DECLARE @_ERR_UNACTIVE_ACCOUNT INT = -49;
	DECLARE @_ERR_USER_NOT_PERMISION INT = -51;
	DECLARE @_ERR_DATA_INVALID INT = -600;
 	DECLARE @_UserID INT,
			@_UsernameIn VARCHAR(50),
			@_EmailIn VARCHAR(150),
 			@_PasswordIn NVARCHAR(100),
 			@_Status BIT,
			@_IsAdmin BIT

	SELECT @_Password = ISNULL(@_Password,'')

	IF(ISNULL(@_Username,'') = '' AND ISNULL(@_Email,'') = '')
	BEGIN
		SET @_ResponseStatus = @_ERR_DATA_INVALID;
		RETURN;
	END

	SELECT @_UserID = UserID,
			@_UsernameIn = Username,
			@_EmailIn = Email,
			@_PasswordIn= [Password],
			@_Status = [Status],
			@_IsAdmin = IsAdministrator
	FROM [dbo].[User]
	WHERE (ISNULL(@_Username,'') = '' OR UserName = @_Username) 
	AND (ISNULL(@_Email,'') = '' OR Email = @_Email)

	SET @_PasswordIn = ISNULL(@_PasswordIn,'');
	SET @_Status = ISNULL(@_Status,0);
	SET @_IsAdmin = ISNULL(@_IsAdmin,0);
	SET @_UsernameIn = ISNULL(@_UsernameIn,'');
	SET @_EmailIn = ISNULL(@_EmailIn,'');

	IF(ISNULL(@_UserID,0) = 0 OR ISNULL(@_UsernameIn,'') = '')
	BEGIN
		SET @_ResponseStatus = @_ERR_NOT_EXIST_ACCOUNT;
		RETURN;
	END

	IF (@_Status = 0)
	BEGIN
		SET @_ResponseStatus = @_ERR_UNACTIVE_ACCOUNT;
		RETURN;
	END
	IF (@_Username <> '' AND @_Password <> @_PasswordIn)
	BEGIN
		SET @_ResponseStatus = @_ERR_INVALID_PASSWORD
		RETURN
	END

	IF(@_IsAdmin = 0 AND ISNULL(@_SystemID,0) > 0 AND NOT EXISTS(SELECT 1 FROM [dbo].[UserSystem] WHERE UserID = @_UserID AND [SystemID] = @_SystemID))
	BEGIN
		SET @_ResponseStatus = @_ERR_USER_NOT_PERMISION
		RETURN
	END

	SELECT TOP 1 u.[UserID],
			[Username],
			[Email],
			[Mobile],
			[FullName],
			[IsAdministrator],
			[CreatedTime],
			u.[CreatedUser],
			[Status],
			CASE WHEN @_IsAdmin = 1 THEN 0 ELSE us.SystemID END SystemID,
			us.IsMod
		FROM [dbo].[User] u LEFT JOIN dbo.[UserSystem] us ON u.UserID = us.UserID
		WHERE u.UserID = @_UserID 
		AND (@_IsAdmin = 1 OR (ISNULL(@_SystemID, 0) = 0 OR us.SystemID = @_SystemID))


	BEGIN TRY		
		
		--Ghi log
		DECLARE @_Desc NVARCHAR(200) = N'Tài khoản dăng nhập hệ thống > LoginBy:' +  CASE WHEN @_Username <> '' THEN @_Username ELSE @_Email END
		DECLARE @_FuncID INT = CASE WHEN @_Username <> '' THEN 9999 ELSE 10000 END
		DECLARE @_FuncName NVARCHAR(200) = N'Đăng Nhập Hệ Thống ' + CASE WHEN @_Username <> '' THEN N'(ByUsername)' ELSE N'(ByEmail)' END

		EXEC [dbo].[SP_UserLogs_Insert]
		@_UserID = @_UserID,
		@_FunctionID = @_FuncID,
		@_FunctionName = @_FuncName,
		@_Description = @_Desc,
		@_LogType = 1,
		@_ClientIP = @_ClientIP,
		@_ResponseCode = @_ResponseStatus OUT
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = -99;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH
END



GO
/****** Object:  StoredProcedure [dbo].[SP_User_ChangePassword]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 01/07/2015
-- Description:	<Them Tai Khoan,,>
--	UserID : 0(insert), #0 : Update
-- =============================================
CREATE PROCEDURE [dbo].[SP_User_ChangePassword]
	 @_Username VARCHAR(50)
	,@_PasswordOld VARCHAR(50)
	,@_PasswordNew VARCHAR(50)
	,@_ResponseCode INT OUTPUT
	
AS
BEGIN
    SET NOCOUNT,XACT_ABORT ON ;
	--SET REMOTE_PROC_TRANSACTIONS OFF;
    DECLARE @_ErrorSystemCode INT;
    SET @_ErrorSystemCode = 1
	--=============Định nghĩa tập mã lỗi trả về =============================================
	DECLARE @_SUCCESSFUL  INT; SET @_SUCCESSFUL=1	
	DECLARE @_ERR_NOT_EXIST_ACCOUNT  INT; SET @_ERR_NOT_EXIST_ACCOUNT=-1 -- Tài khoản đã tồn tại	
	DECLARE @_ERR_ACCOUNT_BLOCK INT = -2
	DECLARE @_ERR_VALID_OLD_PASSWORD  INT; SET @_ERR_VALID_OLD_PASSWORD=-3 -- Mật khẩu cũ không đúng
	DECLARE @_ERR_UNKNOW INT; SET  @_ERR_UNKNOW=-99 -- Lỗi khi thực hiện Inser dữ liệu	
	DECLARE @_ERR_PARAM_INPUT INT; SET @_ERR_PARAM_INPUT = -600

	SELECT	@_Username = ISNULL(@_Username,''), @_PasswordOld = ISNULL(@_PasswordOld,''), @_PasswordNew = ISNULL(@_PasswordNew,'')

	IF(@_Username = '' OR @_PasswordOld = '' OR @_PasswordNew = '')
	BEGIN
		SET @_ResponseCode = @_ERR_PARAM_INPUT
		RETURN;
	END
	DECLARE @_UserID INT, @_UserPasswordIn NVARCHAR(50), @_Status INT
	SELECT @_UserID = UserID,
			@_UserPasswordIn = [Password],
			@_Status = [Status]
			FROM [dbo].[User]
			WHERE UserName = @_UserName

	SET @_UserID = ISNULL(@_UserID,0)
	SET	@_UserPasswordIn = ISNULL(@_UserPasswordIn,'')
	SET	@_Status = ISNULL(@_Status,0)

	IF (@_UserID = 0)
	BEGIN
		SET @_ResponseCode = @_ERR_NOT_EXIST_ACCOUNT;
		RETURN;
	END
	IF (@_Status = 0)
	BEGIN
		SET @_ResponseCode = @_ERR_ACCOUNT_BLOCK;
		RETURN
	END
	IF(@_UserPasswordIn <> @_PasswordOld)
	BEGIN
		SET @_ResponseCode = @_ERR_VALID_OLD_PASSWORD
		RETURN
	END

	BEGIN TRANSACTION
	BEGIN TRY 
		
		UPDATE [dbo].[User]
			SET [Password] = @_PasswordNew
			WHERE  [UserID] = @_UserID
							
		SET @_ResponseCode = @@RowCount
		
		COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = @_ERR_UNKNOW;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[sp_LogError]
						@ErrorCode = @_ResponseCode OUTPUT
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH; 
END






GO
/****** Object:  StoredProcedure [dbo].[SP_User_Delete]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran: DungTD Modified 30/10/2015
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_User_Delete]
	@_UserID int
	,@_ResponseCode int output
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOT_EXIST_ACCOUNT INT = -50;

	IF (NOT EXISTS(SELECT 1 FROM [dbo].[User] WHERE UserID = @_UserID))
	BEGIN
		SET @_ResponseCode = @_ERR_NOT_EXIST_ACCOUNT
		RETURN;
	END

	BEGIN TRANSACTION
	BEGIN TRY
		DELETE [dbo].[UserLogs] WHERE UserID = @_UserID 
		DELETE FROM [dbo].[UserFunction]
		OUTPUT Deleted.* INTO [dbo].[UserFunction_Log]
		WHERE [UserID] = @_UserID 

		DELETE FROM [dbo].[User] WHERE [UserID] = @_UserID
		COMMIT TRANSACTION;
		SET @_ResponseCode = 1
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
		Set @_ResponseCode = -99;
		-- Insert Log
		EXEC	[dbo].[sp_LogError]				
	END CATCH; 
END




GO
/****** Object:  StoredProcedure [dbo].[SP_User_GetByCondition]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_User_GetByCondition]
	@_UserName varchar(50) = ''
	,@_Email VARCHAR(150) = ''
	,@_UserID INT = 0 
	,@_Status INT = -1
	,@_SystemID INT = NULL
	,@_IsMod BIT = NULL
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;
	SELECT DISTINCT uinfo.* FROM
	(
	SELECT [UserID],
			[Username],
			[Email],
			[FullName],
			[Mobile],
			[IsAdministrator],
			[CreatedTime],
			[CreatedUser],
			[Status],
			--[List_SystemID] = STUFF((SELECT DISTINCT ';' + CONVERT(VARCHAR(50),us.SystemID) + ',' + Convert(VARCHAR(20),us.IsMod)
			--   FROM dbo.UserSystem us
			--   WHERE us.UserID = u.UserID
			--  FOR XML PATH('')), 1, 1, ''),
			  [List_GroupID] = STUFF((SELECT DISTINCT ',' + CONVERT(VARCHAR(50),ug.GroupID)
			   FROM dbo.UserGroups ug
			   WHERE ug.UserID = u.UserID
			  FOR XML PATH('')), 1, 1, '')
	FROM dbo.[User] u
	WHERE (ISNULL(@_UserID, 0) = 0 OR UserID = @_UserID)
		AND (ISNULL(@_Status, -1) = -1 OR [Status] = @_Status)
		AND (ISNULL(@_UserName,'') = '' OR Username =	@_UserName )
		AND (ISNULL(@_Email,'') = '' OR Email = @_Email)
	) uinfo
	LEFT JOIN dbo.UserSystem us
	ON uinfo.UserID = us.UserID
	WHERE (ISNULL(@_SystemID, 0) = 0 OR us.SystemID = @_SystemID)
	AND (@_IsMod IS NULL OR us.IsMod = @_IsMod)
END






GO
/****** Object:  StoredProcedure [dbo].[SP_User_GetList_ByRoleFunctionID]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
CREATE PROCEDURE [dbo].[SP_User_GetList_ByRoleFunctionID]
	@_FunctionID int,
	@_IsGrant TINYINT = 2 --tâấ cả, 0: false, 1:true
AS
BEGIN	
	SET NOCOUNT ON;  
	SELECT  UserID, FunctionID, IsGrant, IsInsert, IsUpdate, IsDelete
	FROM dbo.UserFunction uf
	WHERE FunctionID = @_FunctionID AND (ISNULL(@_IsGrant,2) = 2 OR IsGrant = @_IsGrant)
	ORder BY FunctionID
END
GO
/****** Object:  StoredProcedure [dbo].[SP_User_GetPage]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_User_GetPage]
	@_Keyword VARCHAR(50) = ''
	,@_Status INT 	
	,@_IsGrant INT = -1
AS
BEGIN
	SET NOCOUNT ON;

		SELECT 
			u.[UserID],
			u.[Username],
			u.[Email],
			u.[FullName],
			u.[Password],
			u.[IsAdministrator],
			u.[CreatedTime],
			u.[CreatedUser],
			u.[Status]
		FROM [dbo].[User] u
		WHERE (ISNULL(@_Status,-1) = -1 OR [Status] = @_Status)
		AND (ISNULL(@_IsGrant,-1) = -1 OR NOT EXISTS(SELECT 1 FROM [dbo].[UserFunction] Where UserID = u.UserID AND IsGrant = @_IsGrant))
		AND (ISNULL(@_KeyWord, '') = '' OR ([Username] LIKE '%' + @_KeyWord + '%') 
										OR ([Email] LIKE '%' + @_KeyWord + '%')
										OR ([FullName] LIKE '%' + @_KeyWord + '%')
		)
	
END



GO
/****** Object:  StoredProcedure [dbo].[SP_User_InsertUpdate]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 01/07/2015
-- Description:	<Them Tai Khoan,,>
--	UserID : 0(insert), #0 : Update
-- =============================================
CREATE PROCEDURE [dbo].[SP_User_InsertUpdate]
	 @_UserID INT 	
	,@_Username VARCHAR(50)
	,@_Email VARCHAR(150)
	,@_FullName NVARCHAR(150) = ''
	,@_Mobile NVARCHAR(20) = ''
	,@_Password VARCHAR(50)= ''
	,@_IsActive BIT = null
	,@_IsAdministrator BIT = NULL					-- 0: binh thuong, 1:Admin
	,@_CreatedUser	VARCHAR(50)
	,@_GroupID VARCHAR(100) = '' --@_GroupID: 1,2,3,4,5...
	,@_SystemID VARCHAR(100) = '' --SystemID : Sysid, ismod; Sysid2, ismod ....
	,@_ResponseStatus INT OUTPUT
	
AS
DECLARE @GROUPOLDER INT
BEGIN
    SET NOCOUNT,XACT_ABORT ON ;
	--SET REMOTE_PROC_TRANSACTIONS OFF;
    DECLARE @_ErrorSystemCode INT;
    SET @_ErrorSystemCode = 1
	--=============Định nghĩa tập mã lỗi trả về =============================================
	DECLARE @_SUCCESSFUL  INT; SET @_SUCCESSFUL=1	
	DECLARE @_ERR_EXIST_ACCOUNT  INT; SET @_ERR_EXIST_ACCOUNT=-51 -- Tài khoản đã tồn tại		
	DECLARE @_ERR_EXIST_EMAIL INT; SET @_ERR_EXIST_EMAIL = -52
	DECLARE @_ERR_EXIST_MOBILE INT; SET @_ERR_EXIST_MOBILE = -53 
	DECLARE @_ERR_UNKNOW INT; SET  @_ERR_UNKNOW=-99 -- Có lỗi phát sinh từ hệ thống
	DECLARE @_ERR_PARAM_INPUT INT; SET @_ERR_PARAM_INPUT = -600
	DECLARE @_ERR_CREATEDUSER_INVALID INT = -100;
	DECLARE @_ActUserID INT
	SET	@_Username = ISNULL(@_Username,'')
	SET @_Email = ISNULL(@_Email,'')
	SET @_FullName = ISNULL(@_FullName,'')

	--Kiem tra user thuc hien co ton tai ko
	--SELECT @_ActUserID = UserID FROM dbo.[User] WHERE Username = @_CreatedUser

	--IF(ISNULL(@_ActUserID,0) = 0 )
	--BEGIN
	--	SET @_ResponseStatus = @_ERR_CREATEDUSER_INVALID;
	--	RETURN;
	--END

	IF(@_Username = '')
	BEGIN
		SET @_ResponseStatus = @_ERR_PARAM_INPUT
		RETURN;
	END
	IF(ISNULL(@_UserID,0) = 0)
	BEGIN
		IF (EXISTS(SELECT 1 FROM [dbo].[User] WHERE Username = @_Username))
		BEGIN
			SET @_ResponseStatus = @_ERR_EXIST_ACCOUNT;
			RETURN;
		END
		IF (EXISTS (SELECT * FROM [dbo].[User] WHERE [Email] = @_Email))
		BEGIN
			SET @_ResponseStatus = @_ERR_EXIST_EMAIL;
			RETURN;
		END
		--IF (EXISTS (SELECT * FROM [dbo].[User] WHERE [Mobile] = @_Mobile))
		--BEGIN
		--	SET @_ResponseStatus = @_ERR_EXIST_MOBILE;
		--	RETURN;
		--END
	END
	ELSE	
	BEGIN
		IF (EXISTS(SELECT 1 FROM [dbo].[User] WHERE Username = @_Username AND UserID<>@_UserID))
		BEGIN
			SET @_ResponseStatus = @_ERR_EXIST_ACCOUNT;
			RETURN;
		END
	END

	SELECT value INTO #grp_tmp From [dbo].[FN_Parameters_Split](@_GroupID,',')

	DECLARE @tblSystemTemp TABLE(SystemID INT, IsMod BIT)
	IF(ISNULL(@_SystemID,'') <> '' AND LEN(@_SystemID) > 0 AND CHARINDEX(',',@_SystemID) > 0)
	BEGIN
			INSERT INTO @tblSystemTemp(SystemID, IsMod)	
			EXEC SP_SplitToTableWithMultiColumn @Split = @_SystemID, @Delimiter1 = ';', @Delimiter2 = ','	
	END

	--Lấy toàn bộ quyền trong ds group
	DECLARE @lstFn_tmp  TABLE (FunctionID INT, IsGrant BIT, IsInsert BIT, IsUpdate BIT, IsDelete BIT)
	DECLARE @_FunctionId INT,
			@_IsGrant INT,
			@_IsInsert INT,
			@_IsUpdate INT,
			@_IsDelete INT

	IF(EXISTS(SELECT value FROM #grp_tmp))
	BEGIN
		INSERT INTO @lstFn_tmp 
		SELECT FunctionID, 
				MAX(CONVERT(int,IsGrant)) IsGrant,
				MAX(CONVERT(int,IsInsert)) IsInsert,
				MAX(CONVERT(int,IsUpdate)) IsUpdate,
				MAX(CONVERT(int,IsDelete)) IsDelete 
		FROM dbo.GroupFunctions
		WHERE GroupID in (SELECT value FROM #grp_tmp)
		GROUP BY FunctionID
		ORDER BY FunctionID
	END

	BEGIN TRANSACTION
	BEGIN TRY 
		IF ISNULL(@_UserID,0) = 0
			BEGIN
				INSERT INTO [dbo].[User]
						(
						 [Username]
						,[Email]
						,[FullName]
						,[Mobile]
						,[Password]
						,[IsAdministrator]
						,[Status]
						,[CreatedUser]
						,[CreatedTime])
					VALUES
						(
						 @_Username
						,@_Email
						,@_FullName
						,@_Mobile
						,@_Password
						,@_IsAdministrator
						,@_IsActive
						,@_CreatedUser
						,GETDATE())
				SET @_ResponseStatus = @@IDENTITY
				--Map user den system
				IF(EXISTS(SELECT 1 FROM @tblSystemTemp))
				BEGIN
					INSERT INTO [dbo].UserSystem 
					(UserID, SystemID, CreatedDate, CreatedUser, IsMod)
					SELECT @_ResponseStatus UserID, --UserID moi dc them
						   SystemID,
						   GETDATE(),
						   @_CreatedUser,
						   IsMod
					FROM @tblSystemTemp
				END
				
				--nếu user được phân nhóm 
				IF(ISNULL(@_GroupID,'') <> '' AND EXISTS(SELECT 1 FROM @lstFn_tmp))
				BEGIN
					--Them user vào các group
					INSERT INTO [dbo].[UserGroups] (GroupID, UserID, CreatedTime, CreatedUser)
					SELECT value GroupID, @_UserID, GETDATE(), @_CreatedUser 
					From #grp_tmp

					SELECT @_ActUserID = UserID FROM [dbo].[User] WHERE Username = @_CreatedUser
					--thêm quyền cho user dựa theo quyền của các nhóm đã tổng hợp
					INSERT INTO dbo.UserFunction
					(	
						UserID,
						FunctionID,
						CreatedTime,
						IsGrant,
						IsInsert,
						IsUpdate,
						IsDelete,
						CreatedUserID
					)
					SELECT						
						@_ResponseStatus, --UserID moi dc them
						FunctionID,
						GETDATE(),
						IsGrant,
						IsInsert,
						IsUpdate,
						IsDelete,
						@_ActUserID
					FROM @lstFn_tmp
				END
			END			
		ELSE
			BEGIN 	
				--Map user den system
				IF(EXISTS(SELECT 1 FROM @tblSystemTemp))
				BEGIN
					--xoa user system # ds system can map
					DELETE [dbo].UserSystem 
					WHERE UserID = @_UserID AND SystemID not in (SELECT SystemID FROM @tblSystemTemp)
				
					INSERT INTO [dbo].UserSystem (UserID, SystemID, CreatedDate, CreatedUser, IsMod)
					SELECT @_UserID UserID, --UserID moi dc them
							stmp.SystemID,
							GETDATE(),
							@_CreatedUser,
							stmp.IsMod
					FROM @tblSystemTemp stmp
					WHERE stmp.SystemID NOT IN (SELECT SystemID FROM [dbo].UserSystem WHERE UserID = @_UserID)

					UPDATE us
					SET IsMod = stmp.IsMod
					FROM [dbo].UserSystem us
					JOIN @tblSystemTemp stmp
					ON us.SystemID = stmp.SystemID
					WHERE us.UserID = @_UserID
				END

				--Nếu có sự thay đổi về nhóm thì sẽ thực hiện cập nhật
				IF(EXISTS(SELECT 1 FROM @lstFn_tmp))
				BEGIN	
					--Trường hợp cập nhật nhóm cho user thì sẽ xóa toàn bộ quyền cũ # ds quyền đc thêm mới
					DELETE uf FROM [dbo].[UserFunction] uf
					WHERE UserID = @_UserID 
					AND FunctionID not in (Select FunctionID FROM @lstFn_tmp)

					--phân quyền user theo Group
					--Dinh nghia con tro
					DECLARE current_cursor CURSOR FOR
					SELECT FunctionID, IsGrant, IsInsert,IsUpdate, IsDelete FROM #lstFn_tmp
					ORDER BY FunctionID
					--Chạy con trỏ thực hiện phân quyền các chức năng trong bảng #Fntmp
					OPEN current_cursor
					FETCH NEXT FROM current_cursor INTO @_FunctionId, @_IsGrant, @_IsInsert, @_IsUpdate, @_IsDelete

					WHILE @@FETCH_STATUS = 0
					BEGIN
						--Nếu ko tồn tại quyền thì thêm mới
						IF(NOT EXISTS(SELECT 1 FROM [dbo].[UserFunction] WHERE UserID = @_UserID AND FunctionID = @_FunctionId))
						BEGIN 
							INSERT INTO dbo.[UserFunction] (UserID, FunctionID, IsInsert, IsUpdate, IsDelete, CreatedUserID) 
							VALUES (@_UserID, @_FunctionId, @_IsInsert, @_IsUpdate, @_IsDelete, @_ActUserID)
						END
						ELSE
						BEGIN
							UPDATE dbo.[UserFunction] 
							SET IsGrant = @_IsGrant,
								IsInsert = @_IsInsert, 
								IsUpdate = @_IsUpdate, 
								IsDelete = @_IsDelete, 
								CreatedUserID = @_ActUserID
							WHERE UserID = @_UserID AND FunctionID = @_FunctionId
						END
						--Nhảy qua row tiếp theo
						FETCH NEXT FROM current_cursor INTO @_FunctionId, @_IsInsert, @_IsUpdate, @_IsDelete
					END
				END

				UPDATE [dbo].[User]
					SET  Username = CASE WHEN ISNULL(@_Username, '') = '' THEN Username ELSE @_Username END
						,[Email] = CASE WHEN ISNULL(@_Email, '') = '' THEN [Email] ELSE @_Email END
						,[FullName] = CASE WHEN ISNULL(@_FullName, '') = '' THEN FullName ELSE @_FullName END
						,[Mobile] = CASE WHEN ISNULL(@_Mobile, '') = '' THEN Mobile ELSE @_Mobile END
						,[Password] = CASE WHEN ISNULL(@_Password, '') = '' THEN [Password] ELSE @_Password END
						,[Status] =	CASE WHEN @_IsActive IS NULL THEN [Status] ELSE @_IsActive END
						,IsAdministrator = CASE WHEN @_IsAdministrator IS NULL THEN IsAdministrator ELSE @_IsAdministrator END
				WHERE  [UserID] = @_UserID
							
				SET @_ResponseStatus = @_UserID	

			END		
		
		
		COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = @_ERR_UNKNOW;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH; 
END






GO
/****** Object:  StoredProcedure [dbo].[SP_User_UpdateActive]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<quocphong.tran>
-- Create date: <01/05/2015>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_User_UpdateActive]
	-- Add the parameters for the stored procedure here
	@_UserID int,
	@_ResponseCode int out
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;
	DECLARE @_ERR_NOT_EXIST_ACCOUNT INT = -50
	DECLARE @_ERR_UNKNOWN INT = -99
	IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [UserID] = @_UserID)
    BEGIN
		SET @_ResponseCode = @_ERR_NOT_EXIST_ACCOUNT
		RETURN
    END
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE  @_IsDisplay INT;
	
		SELECT @_IsDisplay = [Status]
		FROM [dbo].[User]
		WHERE [UserID] = @_UserID

		IF (ISNULL(@_IsDisplay, -1) <= 0)
		BEGIN
			UPDATE [dbo].[User]
			SET [Status] = 1
			WHERE [UserID] = @_UserID
			SET @_ResponseCode=@_UserID
		END
		ELSE
			BEGIN
				UPDATE [dbo].[User]
				SET [Status] = 0
				WHERE [UserID] = @_UserID
				SET @_ResponseCode=@_UserID
			END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = @_ERR_UNKNOWN;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[sp_LogError]
						@ErrorCode = @_ResponseCode OUTPUT
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH
END




GO
/****** Object:  StoredProcedure [dbo].[SP_UserFunction_Delete]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		DungTD
-- Create date:	<30/10/2015>
-- Description: Xóa quyền User theo chức năng (functionID)
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserFunction_Delete]
	 @_UserID int
	,@_FunctionID int
	,@_ResponseCode	int output
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM [dbo].[UserFunction]
		OUTPUT Deleted.* INTO [dbo].[UserFunction_Log]
		WHERE [UserID] = @_UserID AND FunctionID = @_FunctionID

		IF(@_ResponseCode < 0) 
		BEGIN
			ROLLBACK TRANSACTION;
			RETURN;
		END

		SET @_ResponseCode = 1
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = -99;
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;		
		EXEC	[dbo].[sp_LogError]							
	END CATCH; 
END




GO
/****** Object:  StoredProcedure [dbo].[SP_UserFunction_DeleteAllByUserID]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		DungTD
-- Create date:	<30/10/2015>
-- Description: Xóa quyền User
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserFunction_DeleteAllByUserID]
	 @_UserID int
	,@_ResponseCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM [dbo].[UserFunction]
		OUTPUT Deleted.* INTO [dbo].[UserFunction_Log]
		WHERE [UserID] = @_UserID 

		IF(@_ResponseCode < 0) 
		BEGIN
			ROLLBACK TRANSACTION;
			RETURN;
		END

		SET @_ResponseCode = 1
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = -99;
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;		
		EXEC	[dbo].[sp_LogError]							
	END CATCH; 
END




GO
/****** Object:  StoredProcedure [dbo].[SP_UserFunction_DeleteList]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		DungTD
-- Create date:	<30/10/2015>
-- Description: Xóa quyền User theo chức năng (functionID)
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserFunction_DeleteList]
	 @_UserID int
	,@_FunctionID NVARCHAR(4000)
	,@_ResponseCode	int output
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		
		DELETE FROM [dbo].[UserFunction]
		OUTPUT Deleted.* INTO [dbo].[UserFunction_Log]
		WHERE [UserID] = @_UserID AND 
		FunctionID IN (SELECT Cast(Value as INT) FROM dbo.FN_Parameters_Split(@_FunctionID, ','))

		IF(@_ResponseCode < 0) 
		BEGIN
			ROLLBACK TRANSACTION;
			RETURN;
		END

		SET @_ResponseCode = 1
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = -99;
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;		
		EXEC	[dbo].[sp_LogError]							
	END CATCH; 
END




GO
/****** Object:  StoredProcedure [dbo].[SP_UserFunction_GetByUserID]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		phongtq
-- Create date:	<30/10/2015>
-- Description: Lấy tất cả quyền User
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserFunction_GetByUserID]
	@_UserID int
AS
BEGIN	
	SET NOCOUNT ON;  
	SELECT  uf.*, f.ActionName,
	[dbo].[FN_GetParentID](uf.[FunctionID]) AS ParentID,
	[dbo].[FN_GetParentName]([dbo].[FN_GetParentID](uf.[FunctionID])) AS ParentName 
	FROM dbo.UserFunction uf
	Inner Join dbo.Functions f
	ON uf.FunctionID = f.FunctionID
	WHERE UserID = @_UserID ORDER BY ParentID, CreatedTime ASC
END



GO
/****** Object:  StoredProcedure [dbo].[SP_UserFunction_Insert]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		phongtq
-- Create date:	<30/10/2015>
-- Description: Phan user co quyen voi function va nhung service nao 
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserFunction_Insert]
	 @_UserID  INT
	,@_PermissionOfFnIDs NVARCHAR(MAX)	--FunctionID,IsGrant,IsInsert,IsUpdate,IsDelete;...
	,@_CreatedUserID INT
	,@_IsAdmin	BIT = 1
	,@_ResponseCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOT_EXIST_ACCOUNT INT = -50
	DECLARE @_ERR_UNKNOWN INT = -99
	IF NOT EXISTS (SELECT UserID FROM [dbo].[User] WHERE [UserID] = @_UserID)
    BEGIN
		SET @_ResponseCode = @_ERR_NOT_EXIST_ACCOUNT
		RETURN
    END
	IF(ISNULL(@_PermissionOfFnIDs,'') = '')
	BEGIN
		SET @_ResponseCode = -600
		RETURN
    END
	BEGIN TRANSACTION
	BEGIN TRY
			
			DECLARE @tblFunctionID TABLE(FunctionID INT, IsGrant BIT, IsInsert BIT, IsUpdate BIT, IsDelete BIT)
			INSERT INTO @tblFunctionID(FunctionID, IsGrant, IsInsert, IsUpdate, IsDelete)	
			EXEC SP_SplitToTableWithMultiColumn @Split = @_PermissionOfFnIDs, @Delimiter1 = ';', @Delimiter2 = ','	

			IF(@_IsAdmin = 1)--neu la admin phan quyen lai thi xoa tat
			BEGIN
				DELETE FROM dbo.UserFunction 
				OUTPUT Deleted.* INTO dbo.UserFunction_Log
				WHERE UserID = @_UserID
				
			END
			ELSE -- khong thi chi xoa theo list functionid chuyen vao
			BEGIN
				DELETE FROM dbo.UserFunction 
				OUTPUT Deleted.* INTO dbo.UserFunction_Log
				WHERE UserID = @_UserID AND FunctionID IN (SELECT FunctionID FROM @tblFunctionID)
			END

			DECLARE	@Now DATETIME = GETDATE();								
			INSERT INTO [dbo].[UserFunction]
						  (
							   [UserID]
							  ,[FunctionID]							
							  ,[IsGrant]
							  ,[IsInsert]
							  ,[IsUpdate]
							  ,[IsDelete]
							  ,[CreatedTime]
							  ,[CreatedUserID]
						  )
			SELECT DISTINCT @_UserID, FunctionID, IsGrant, IsInsert, IsUpdate, IsDelete, @Now, @_CreatedUserID 
			FROM @tblFunctionID
		
		 SET @_ResponseCode = 1;
		 COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		SET @_ResponseCode = @_ERR_UNKNOWN;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;			
		EXEC	[dbo].[sp_LogError]			
			
	END CATCH; 
END




GO
/****** Object:  StoredProcedure [dbo].[SP_UserFunction_InsertList_byFunctionID]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		phongtq
-- Create date:	<30/10/2015>
-- Description: Phan danh sach user co quyen voi functionID
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserFunction_InsertList_byFunctionID]
	 @_FunctionID  INT
	,@_PermissionOfUsers NVARCHAR(MAX)	--UserID,IsInsert,IsUpdate,IsDelete;...
	,@_CreatedUserID INT
	,@_ResponseCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOT_EXIST_FUNCTION INT = -101
	DECLARE @_ERR_UNKNOWN INT = -99
	IF NOT EXISTS (SELECT FunctionID FROM [dbo].[Functions] WHERE [FunctionID] = @_FunctionID)
    BEGIN
		SET @_ResponseCode = @_ERR_NOT_EXIST_FUNCTION
		RETURN
    END
	IF(ISNULL(@_PermissionOfUsers,'') = '')
	BEGIN
		SET @_ResponseCode = -600
		RETURN
    END
	BEGIN TRANSACTION
	BEGIN TRY
			
			DECLARE @tblUserFunction TABLE(UserID INT, IsInsert BIT, IsUpdate BIT, IsDelete BIT)
			INSERT INTO @tblUserFunction(UserID, IsInsert, IsUpdate, IsDelete)	
			EXEC SP_SplitToTableWithMultiColumn 
			@Split = @_PermissionOfUsers, @Delimiter1 = ';', @Delimiter2 = ','	

			DELETE FROM dbo.UserFunction 
			OUTPUT Deleted.* INTO dbo.UserFunction_Log
			WHERE FunctionID = @_FunctionID AND UserID IN (SELECT UserID FROM @tblUserFunction)

			DECLARE	@Now DATETIME = GETDATE();								
			INSERT INTO [dbo].[UserFunction]
			(
				[UserID]
				,[FunctionID]							
				,[IsGrant]
				,[IsInsert]
				,[IsUpdate]
				,[IsDelete]
				,[CreatedTime]
				,[CreatedUserID]
			)
			SELECT DISTINCT UserID, @_FunctionID, 0, IsInsert, IsUpdate, IsDelete, @Now, @_CreatedUserID 
			FROM @tblUserFunction
		
		 SET @_ResponseCode = 1;
		 COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		SET @_ResponseCode = @_ERR_UNKNOWN;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;			
		EXEC	[dbo].[sp_LogError]			
			
	END CATCH; 
END




GO
/****** Object:  StoredProcedure [dbo].[SP_UserLogs_Delete]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserLogs_Delete]
	 @_Fromdate datetime = null
	,@_Todate datetime=null
	,@_UserID int=null
	,@_FunctionID int=null
	,@_ResponseCode int OUTPUT
AS
BEGIN	
	SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM UserLogs
		WHERE  (@_UserID IS NULL OR UserLogs.UserID=@_UserID)
				AND (@_FunctionID IS NULL OR UserLogs.FunctionID=@_FunctionID)
				AND (@_Fromdate IS NULL OR UserLogs.CreatedTime >=@_Fromdate)
				AND (@_Todate IS NULL OR UserLogs.CreatedTime <= @_Todate)
		SET @_ResponseCode = 0
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = -99;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[sp_LogError]
						@ErrorCode = @_ResponseCode OUTPUT
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH
END




GO
/****** Object:  StoredProcedure [dbo].[SP_UserLogs_GetPages]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserLogs_GetPages] 
	@_Fromdate datetime =null
	,@_Todate datetime = null
	,@_UserID int = null
	,@_FunctionID int =null	
AS
BEGIN
	SET @_Fromdate = ISNULL(@_Fromdate,DATEADD(DAY,-7,GETDATE()))
	SET @_Todate = ISNULL(@_Todate, GETDATE())

	SELECT ul.*
	FROM dbo.UserLogs ul 
	WHERE (ISNULL(@_UserID,-1) = -1 OR ul.UserID = @_UserID)
			AND (ISNULL(@_FunctionID, -1) = -1 OR ul.FunctionID = @_FunctionID)
			AND ul.CreatedTime BETWEEN @_Fromdate AND @_Todate	
	Order by LogID desc

END




GO
/****** Object:  StoredProcedure [dbo].[SP_UserLogs_Insert]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserLogs_Insert]
	@_UserID int
	,@_FunctionID int
	,@_FunctionName nvarchar(100) = ''
	,@_Description nvarchar(1000)
	,@_LogType int = 0
	,@_ClientIP varchar(20) = null
	,@_ResponseCode int OUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON
	SET @_ResponseCode = -99
	SET @_LogType = ISNULL(@_LogType,0)
	SET @_ClientIP = ISNULL(@_ClientIP,'')
	DECLARE @_Username varchar(50) = ''
	DECLARE @_Fullname nvarchar(100) = ''

	SELECT @_Username = ISNULL(Username,''), @_Fullname = ISNULL(Fullname,'') 
	From dbo.[User] Where UserID = @_UserID

	BEGIN TRANSACTION
	BEGIN TRY
		
				INSERT INTO UserLogs
					( UserID
					,Username
					,Fullname
					 ,FunctionID
					 ,FunctionName
					 ,CreatedTime
					 ,[Description]
					 ,[LogType]
					 ,[ClientIP]
					 )
				VALUES
					(@_UserID
					,@_Username
					,@_Fullname
					,@_FunctionID
					,@_FunctionName
					,GETDATE()
					,@_Description
					,@_LogType
					,@_ClientIP
					)

			SET @_ResponseCode = 1
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = -99;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[sp_LogError]
						@ErrorCode = @_ResponseCode OUTPUT
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH
END






GO
/****** Object:  StoredProcedure [dbo].[SP_UserSystem_ActiveOrStandBy]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		phongtq
-- Create date:	<30/10/2015>
-- Description: Map User vao System (Active/StandBy)
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserSystem_ActiveOrStandBy]
	 @_UserID  INT
	,@_SystemID INT	
	,@_CreatedUser VARCHAR(50)
	,@_ResponseCode INT OUTPUT	
AS
BEGIN
    SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOT_EXIST_ACCOUNT INT = -50
	DECLARE @_ERR_UNKNOWN INT = -99,
			@_ERR_CREATED_USER_NOTEXISTS INT = -51,
			@_ERR_CREATED_USER_NOTPERMISSION INT = -52,
			@_ActUserID INT,
			@_ActUserSystem INT,
			@_ActUserIsMod BIT

	--Kiem tra User thuc hien
	SELECT @_ActUserID = u.UserID, @_ActUserSystem = us.SystemID, @_ActUserIsMod = us.IsMod
	FROM dbo.[User] u LEFT JOIN dbo.[UserSystem] us ON u.UserID = us.UserID
	WHERE u.Username = @_CreatedUser AND us.SystemID = @_SystemID

	IF(ISNULL(@_ActUserID,0) = 0)
	BEGIN
		SET @_ResponseCode = @_ERR_CREATED_USER_NOTEXISTS;
		RETURN
	END
	--Kiem  tra quyen User co phai la mod cua system nay ko
	IF(ISNULL(@_ActUserSystem,0) = 0 OR ISNULL(@_ActUserIsMod, 0) = 0)
	BEGIN
		SET @_ResponseCode = @_ERR_CREATED_USER_NOTPERMISSION
		RETURN
	END


	IF NOT EXISTS (SELECT [UserID] FROM [dbo].[User] WHERE [UserID] = @_UserID)
    BEGIN
		SET @_ResponseCode = @_ERR_NOT_EXIST_ACCOUNT
		RETURN
    END
	IF(ISNULL(@_SystemID,0) <= 0)
	BEGIN
		SET @_ResponseCode = -600
		RETURN
    END
			
	BEGIN TRANSACTION
	BEGIN TRY
			IF(EXISTS(SELECT 1 FROM [dbo].[UserSystem] WHERE UserID = @_UserID AND SystemID = @_SystemID))
			BEGIN
				DELETE [dbo].[UserSystem] WHERE UserID = @_UserID AND SystemID = @_SystemID
			END
			ELSE BEGIN
				INSERT INTO  [dbo].[UserSystem] (UserID, SystemID, CreatedDate, CreatedUser)
				VALUES (@_UserID, @_SystemID, GETDATE(), @_CreatedUser)
			END
				
			SET @_ResponseCode = 1

		 COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseCode = @_ERR_UNKNOWN;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
						@ErrorCode = @_ResponseCode OUTPUT
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;	
	END CATCH; 
END




GO
/****** Object:  StoredProcedure [dbo].[SP_UserSystem_GetList]    Script Date: 7/23/2020 3:10:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UserSystem_GetList]
	@_UserID INT,
	@_SystemID INT = 0
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;

	SELECT *
	FROM [dbo].[UserSystem]
	WHERE UserID = @_UserID 
	AND (ISNULL(@_SystemID,0) = 0 OR SystemID = @_SystemID)
END






GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : Log chuc nang, 1 : Log Login, 3: Log đôi mật khẩu' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserLogs', @level2type=N'COLUMN',@level2name=N'LogType'
GO
USE [master]
GO
ALTER DATABASE [wUtility.AdminCMS] SET  READ_WRITE 
GO
```