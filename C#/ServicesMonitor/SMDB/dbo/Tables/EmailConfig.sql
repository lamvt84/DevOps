﻿CREATE TABLE [dbo].[EmailConfig]
(
	[Id] INT NOT NULL IDENTITY(1,1),
    [AlertConfigId] INT NOT NULL,
	[SenderName] VARCHAR(50) NULL, 
    [ToMail] VARCHAR(50) NULL, 
    [CCMail] VARCHAR(500) NULL, 
    [Subject] NVARCHAR(250) NULL, 
    [Message] NVARCHAR(MAX) NULL, 
    [IsResend] BIT NOT NULL CONSTRAINT DF_EmailConfig_IsResend DEFAULT 0, 
    [ServiceId] INT NOT NULL CONSTRAINT DF_EmailConfig_ServiceId DEFAULT 0, 
    [SmsEmailId] INT NOT NULL CONSTRAINT DF_EmailConfig_SmsEmail DEFAULT 0, 
    [LangId] INT NOT NULL CONSTRAINT DF_EmailConfig_LangId DEFAULT 0,
    [DataSign] VARCHAR(100) NULL,
    [IsEnable] BIT NOT NULL CONSTRAINT DF_EmailConfig_IsEnable DEFAULT 1,
    [CreatedTime] DATETIMEOFFSET NOT NULL CONSTRAINT DF_EmailConfig_CreatedTime DEFAULT SYSDATETIMEOFFSET(),
    [UpdatedTime] DATETIMEOFFSET NULL,
    CONSTRAINT PK_EmailConfig PRIMARY KEY CLUSTERED (Id)
)
