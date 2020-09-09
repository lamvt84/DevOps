﻿CREATE TABLE [dbo].[ServicesLog]
(
 	[Id] BIGINT NOT NULL IDENTITY(1,1), 
    [JournalGuid] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedTime] DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
    [ServiceId] INT NOT NULL, 
    [ServiceUrl] VARCHAR(200) NOT NULL,
    [ServiceStatus] VARCHAR(100) NULL,
    CONSTRAINT PK_ServicesLog PRIMARY KEY CLUSTERED (Id)
)