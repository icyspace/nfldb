﻿

/****** Object:  Schema [LandNFL]    Script Date: 1/25/2018 4:45:00 PM ******/
CREATE SCHEMA [LandNFL]
GO
/****** Object:  Schema [MasterNFL]    Script Date: 1/25/2018 4:45:00 PM ******/
CREATE SCHEMA [MasterNFL]
GO
/****** Object:  Schema [NFLDB]    Script Date: 1/25/2018 4:45:00 PM ******/
CREATE SCHEMA [NFLDB]
GO
/****** Object:  Schema [SRCNFL]    Script Date: 1/25/2018 4:45:01 PM ******/
CREATE SCHEMA [SRCNFL]
GO
/****** Object:  Schema [srcRNK]    Script Date: 1/25/2018 4:45:01 PM ******/
CREATE SCHEMA [srcRNK]
GO
/****** Object:  Table [srcRNK].[Schedule]    Script Date: 1/25/2018 4:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [srcRNK].[Schedule](
	[ScheduleXML] [xml] NULL
)

GO
/****** Object:  View [srcRNK].[Schedule_vw]    Script Date: 1/25/2018 4:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [srcRNK].[Schedule_vw] AS 

SELECT 
	  wy.value('@y', 'smallint') AS seasonyear,
	  wy.value('@t', 'varchar(4)') AS seasontype,
      wy.value('@w', 'smallint') AS wkNumber,
	  gd.value('@eid','int') AS eid,
	  gd.value('@gsis', 'int') AS gsis,
	  gd.value('@d', 'varchar(3)') AS [dayName],
	  gd.value('@t', 'time') AS Gametime,	  
      CONVERT(DATETIME, gd.value('@t', 'time')) AT TIME ZONE 'Eastern Standard Time' AT TIME ZONE 'UTC' AS GameTimeUTC,
	  gd.value('@q', 'varchar(1)') AS q,
	  gd.value('@k', 'varchar(1)') AS k,
	  gd.value('@h', 'varchar(8)') AS hometeam,
	  gd.value('@hnn', 'varchar(32)') AS hometeamname,
	  gd.value('@v', 'varchar(8)') AS vrteam,
	  gd.value('@vnn', 'varchar(32)') AS vrteamname

FROM 
      srcRNK.Schedule
	  CROSS APPLY schedulexml.nodes('/ss/gms') AS WeekYr(wy)
	  CROSS APPLY schedulexml.nodes('/ss/gms/g') AS game(gd)




GO
/****** Object:  Table [LandNFL].[Schedule]    Script Date: 1/25/2018 4:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LandNFL].[Schedule](
	[ScheduleXML] [xml] NULL
)

GO
/****** Object:  View [LandNFL].[Schedule_vw]    Script Date: 1/25/2018 4:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW	[LandNFL].[Schedule_vw] AS 

SELECT 
	  gd.value('@eid','int') AS eid,
	  gd.value('@gsis', 'int') AS gsis,
	  wy.value('@y', 'smallint') AS SeasonYear,
	  wy.value('@t', 'varchar(4)') AS SeasonType,
	  gd.value('@gt', 'varchar(4)') AS SeasonTypeDetail,
      wy.value('@w', 'smallint') AS wkNumber,
	  gd.value('@d', 'varchar(3)') AS [dayName],
	  gd.value('@t', 'time') AS GameTime,	  
     CONVERT(TIME, CONVERT(DATETIME, gd.value('@t', 'time')) AT TIME ZONE 'Eastern Standard Time' AT TIME ZONE 'UTC') AS GameTimeUTC,
	  gd.value('@q', 'varchar(1)') AS Qtr,
	  gd.value('@h', 'varchar(8)') AS HomeTeam,
	  gd.value('@hnn', 'varchar(32)') AS HomeTeamName,
	  gd.value('@v', 'varchar(8)') AS AwayTeam,
	  gd.value('@vnn', 'varchar(32)') AS AwayTeamName

FROM 
      LandNFL.Schedule
	  CROSS APPLY schedulexml.nodes('/ss/gms') AS WeekYr(wy)
	  CROSS APPLY schedulexml.nodes('/ss/gms/g') AS game(gd)








GO
/****** Object:  Table [MasterNFL].[Schedule]    Script Date: 1/25/2018 4:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MasterNFL].[Schedule](
	[eid] [int] NOT NULL,
	[gsis] [int] NOT NULL,
	[SeasonYear] [smallint] NULL,
	[SeasonType] [varchar](4) NULL,
	[SeasonTypeDetail] [varchar](4) NULL,
	[wkNumber] [smallint] NULL,
	[DayName] [varchar](3) NULL,
	[GameTime] [time](7) NULL,
	[GameTimeUTC] [time](7) NULL,
	[Qtr] [varchar](1) NULL,
	[HomeTeam] [varchar](8) NULL,
	[HomeTeamName] [varchar](32) NULL,
	[AwayTeam] [varchar](8) NULL,
	[AwayTeamName] [varchar](32) NULL,
	[createts] [datetime] NULL,
	[modifyts] [datetime] NULL,
	[deletets] [datetime] NULL,
 CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED 
(
	[eid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  View [NFLDB].[Schedule_vw]    Script Date: 1/25/2018 4:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [NFLDB].[Schedule_vw]
AS

SELECT 
	eid GameID,
    SeasonYear ,
    SeasonType ,
    SeasonTypeDetail ,
    wkNumber ,
    DayName ,
    GameTime ,
    GameTimeUTC ,
    Qtr ,
    HomeTeam ,
    HomeTeamName ,
    AwayTeam ,
    AwayTeamName 

  FROM [MasterNFL].[Schedule]
  WHERE	 deletets IS NULL 


GO
/****** Object:  Table [dbo].[ProcedureLog]    Script Date: 1/25/2018 4:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcedureLog](
	[ProcedureLogKey] [int] IDENTITY(1,1) NOT NULL,
	[ProcessName] [nvarchar](256) NULL,
	[SchemaName] [nvarchar](256) NULL,
	[ProcedureName] [varchar](300) NULL,
	[TableName] [nvarchar](256) NULL,
	[RecordsReceived] [int] NULL,
	[RecordsInserted] [int] NULL,
	[RecordsUpdated] [int] NULL,
	[RecordsDeleted] [int] NULL,
	[StartTime] [datetimeoffset](7) NULL,
	[EndTime] [datetimeoffset](7) NULL,
	[Duration] [int] NULL
)

GO
/****** Object:  Table [LandNFL].[drive]    Script Date: 1/25/2018 4:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LandNFL].[drive](
	[eid] [int] NOT NULL,
	[drivenumber] [int] NOT NULL,
	[end-qtr] [varchar](50) NULL,
	[end-team] [varchar](50) NULL,
	[end-time] [varchar](50) NULL,
	[end-yrdln] [varchar](50) NULL,
	[fds] [varchar](50) NULL,
	[numplays] [varchar](50) NULL,
	[penyds] [varchar](50) NULL,
	[posteam] [varchar](50) NULL,
	[postime] [varchar](50) NULL,
	[qtr] [varchar](50) NULL,
	[redzone] [varchar](50) NULL,
	[result] [varchar](50) NULL,
	[start-qtr] [varchar](50) NULL,
	[start-team] [varchar](50) NULL,
	[start-time] [varchar](50) NULL,
	[start-yrdln] [varchar](50) NULL,
	[ydsgained] [varchar](50) NULL,
 CONSTRAINT [PK_drive] PRIMARY KEY CLUSTERED 
(
	[eid] ASC,
	[drivenumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [LandNFL].[game]    Script Date: 1/25/2018 4:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LandNFL].[game](
	[eid] [int] NOT NULL,
	[home-abbr] [varchar](50) NULL,
	[home-players] [varchar](50) NULL,
	[away-to] [varchar](50) NULL,
	[away-score-1] [varchar](50) NULL,
	[away-score-2] [varchar](50) NULL,
	[away-score-3] [varchar](50) NULL,
	[away-score-4] [varchar](50) NULL,
	[away-score-5] [varchar](50) NULL,
	[away-score-T] [varchar](50) NULL,
	[away-stats-team-totfd] [varchar](50) NULL,
	[away-stats-team-pt] [varchar](50) NULL,
	[away-stats-team-ptyds] [varchar](50) NULL,
	[away-stats-team-trnovr] [varchar](50) NULL,
	[away-stats-team-pyds] [varchar](50) NULL,
	[away-stats-team-ryds] [varchar](50) NULL,
	[away-stats-team-totyds] [varchar](50) NULL,
	[away-stats-team-ptavg] [varchar](50) NULL,
	[away-stats-team-pen] [varchar](50) NULL,
	[away-stats-team-penyds] [varchar](50) NULL,
	[away-stats-team-top] [varchar](50) NULL,
	[away-abbr] [varchar](50) NULL,
	[away-players] [varchar](50) NULL,
	[home-to] [varchar](50) NULL,
	[home-score-1] [varchar](50) NULL,
	[home-score-2] [varchar](50) NULL,
	[home-score-3] [varchar](50) NULL,
	[home-score-4] [varchar](50) NULL,
	[home-score-5] [varchar](50) NULL,
	[home-score-T] [varchar](50) NULL,
	[home-stats-team-totfd] [varchar](50) NULL,
	[home-stats-team-pt] [varchar](50) NULL,
	[home-stats-team-ptyds] [varchar](50) NULL,
	[home-stats-team-trnovr] [varchar](50) NULL,
	[home-stats-team-pyds] [varchar](50) NULL,
	[home-stats-team-ryds] [varchar](50) NULL,
	[home-stats-team-totyds] [varchar](50) NULL,
	[home-stats-team-ptavg] [varchar](50) NULL,
	[home-stats-team-pen] [varchar](50) NULL,
	[home-stats-team-penyds] [varchar](50) NULL,
	[home-stats-team-top] [varchar](50) NULL,
 CONSTRAINT [PK_game] PRIMARY KEY CLUSTERED 
(
	[eid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [LandNFL].[play]    Script Date: 1/25/2018 4:45:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LandNFL].[play](
	[eid] [int] NOT NULL,
	[drivenumber] [int] NOT NULL,
	[playnumber] [int] NOT NULL,
	[posteam] [varchar](50) NULL,
	[desc] [varchar](5000) NULL,
	[ydstogo] [varchar](50) NULL,
	[note] [varchar](50) NULL,
	[qtr] [varchar](50) NULL,
	[yrdln] [varchar](50) NULL,
	[sp] [varchar](50) NULL,
	[down] [varchar](50) NULL,
	[time] [varchar](50) NULL,
	[ydsnet] [varchar](50) NULL,
 CONSTRAINT [PK_pplay] PRIMARY KEY CLUSTERED 
(
	[eid] ASC,
	[drivenumber] ASC,
	[playnumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [LandNFL].[playplayer]    Script Date: 1/25/2018 4:45:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LandNFL].[playplayer](
	[eid] [int] NOT NULL,
	[drivenumber] [int] NOT NULL,
	[playnumber] [int] NOT NULL,
	[playerid] [varchar](50) NOT NULL,
	[statId] [varchar](50) NULL,
	[sequence] [varchar](50) NULL,
	[playerName] [varchar](50) NULL,
	[clubcode] [varchar](50) NULL,
	[yards] [varchar](50) NULL,
 CONSTRAINT [PK_pplayplayer] PRIMARY KEY CLUSTERED 
(
	[eid] ASC,
	[drivenumber] ASC,
	[playnumber] ASC,
	[playerid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [MasterNFL].[drive]    Script Date: 1/25/2018 4:45:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MasterNFL].[drive](
	[eid] [int] NOT NULL,
	[drivenumber] [int] NOT NULL,
	[end-qtr] [varchar](50) NULL,
	[end-team] [varchar](50) NULL,
	[end-time] [varchar](50) NULL,
	[end-yrdln] [varchar](50) NULL,
	[fds] [varchar](50) NULL,
	[numplays] [varchar](50) NULL,
	[penyds] [varchar](50) NULL,
	[posteam] [varchar](50) NULL,
	[postime] [varchar](50) NULL,
	[qtr] [varchar](50) NULL,
	[redzone] [varchar](50) NULL,
	[result] [varchar](50) NULL,
	[start-qtr] [varchar](50) NULL,
	[start-team] [varchar](50) NULL,
	[start-time] [varchar](50) NULL,
	[start-yrdln] [varchar](50) NULL,
	[ydsgained] [varchar](50) NULL,
	[createts] [datetime] NULL,
	[modifyts] [datetime] NULL,
	[deletets] [datetime] NULL,
 CONSTRAINT [PK_drive] PRIMARY KEY CLUSTERED 
(
	[eid] ASC,
	[drivenumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [MasterNFL].[game]    Script Date: 1/25/2018 4:45:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MasterNFL].[game](
	[eid] [int] NOT NULL,
	[home-abbr] [varchar](50) NULL,
	[home-players] [varchar](50) NULL,
	[away-to] [varchar](50) NULL,
	[away-score-1] [varchar](50) NULL,
	[away-score-2] [varchar](50) NULL,
	[away-score-3] [varchar](50) NULL,
	[away-score-4] [varchar](50) NULL,
	[away-score-5] [varchar](50) NULL,
	[away-score-T] [varchar](50) NULL,
	[away-stats-team-totfd] [varchar](50) NULL,
	[away-stats-team-pt] [varchar](50) NULL,
	[away-stats-team-ptyds] [varchar](50) NULL,
	[away-stats-team-trnovr] [varchar](50) NULL,
	[away-stats-team-pyds] [varchar](50) NULL,
	[away-stats-team-ryds] [varchar](50) NULL,
	[away-stats-team-totyds] [varchar](50) NULL,
	[away-stats-team-ptavg] [varchar](50) NULL,
	[away-stats-team-pen] [varchar](50) NULL,
	[away-stats-team-penyds] [varchar](50) NULL,
	[away-stats-team-top] [varchar](50) NULL,
	[away-abbr] [varchar](50) NULL,
	[away-players] [varchar](50) NULL,
	[home-to] [varchar](50) NULL,
	[home-score-1] [varchar](50) NULL,
	[home-score-2] [varchar](50) NULL,
	[home-score-3] [varchar](50) NULL,
	[home-score-4] [varchar](50) NULL,
	[home-score-5] [varchar](50) NULL,
	[home-score-T] [varchar](50) NULL,
	[home-stats-team-totfd] [varchar](50) NULL,
	[home-stats-team-pt] [varchar](50) NULL,
	[home-stats-team-ptyds] [varchar](50) NULL,
	[home-stats-team-trnovr] [varchar](50) NULL,
	[home-stats-team-pyds] [varchar](50) NULL,
	[home-stats-team-ryds] [varchar](50) NULL,
	[home-stats-team-totyds] [varchar](50) NULL,
	[home-stats-team-ptavg] [varchar](50) NULL,
	[home-stats-team-pen] [varchar](50) NULL,
	[home-stats-team-penyds] [varchar](50) NULL,
	[home-stats-team-top] [varchar](50) NULL,
	[createts] [datetime] NULL,
	[modifyts] [datetime] NULL,
	[deletets] [datetime] NULL,
 CONSTRAINT [PK_game] PRIMARY KEY CLUSTERED 
(
	[eid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [MasterNFL].[play]    Script Date: 1/25/2018 4:45:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MasterNFL].[play](
	[eid] [int] NOT NULL,
	[drivenumber] [int] NOT NULL,
	[playnumber] [int] NOT NULL,
	[posteam] [varchar](50) NULL,
	[desc] [varchar](5000) NULL,
	[ydstogo] [varchar](50) NULL,
	[note] [varchar](50) NULL,
	[qtr] [varchar](50) NULL,
	[yrdln] [varchar](50) NULL,
	[sp] [varchar](50) NULL,
	[down] [varchar](50) NULL,
	[time] [varchar](50) NULL,
	[ydsnet] [varchar](50) NULL,
	[createts] [datetime] NULL,
	[modifyts] [datetime] NULL,
	[deletets] [datetime] NULL,
 CONSTRAINT [PK_pplay] PRIMARY KEY CLUSTERED 
(
	[eid] ASC,
	[drivenumber] ASC,
	[playnumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [MasterNFL].[playplayer]    Script Date: 1/25/2018 4:45:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MasterNFL].[playplayer](
	[eid] [int] NOT NULL,
	[drivenumber] [int] NOT NULL,
	[playnumber] [int] NOT NULL,
	[playerid] [varchar](50) NOT NULL,
	[statId] [varchar](50) NULL,
	[sequence] [varchar](50) NULL,
	[playerName] [varchar](50) NULL,
	[clubcode] [varchar](50) NULL,
	[yards] [varchar](50) NULL,
	[createts] [datetime] NULL,
	[modifyts] [datetime] NULL,
	[deletets] [datetime] NULL,
 CONSTRAINT [PK_pplayplayer] PRIMARY KEY CLUSTERED 
(
	[eid] ASC,
	[drivenumber] ASC,
	[playnumber] ASC,
	[playerid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [NFLDB].[Schedule]    Script Date: 1/25/2018 4:45:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NFLDB].[Schedule](
	[ScheduleKey] [int] IDENTITY(1,1) NOT NULL,
	[GameID] [int] NOT NULL,
	[SeasonYear] [smallint] NULL,
	[SeasonType] [varchar](4) NULL,
	[SeasonTypeDetail] [varchar](4) NULL,
	[WkNumber] [smallint] NULL,
	[DayName] [varchar](3) NULL,
	[GameTime] [time](7) NULL,
	[GameTimeUTC] [time](7) NULL,
	[Qtr] [varchar](1) NULL,
	[HomeTeam] [varchar](8) NULL,
	[HomeTeamName] [varchar](32) NULL,
	[AwayTeam] [varchar](8) NULL,
	[AwayTeamName] [varchar](32) NULL,
 CONSTRAINT [PK_Schedule_1] PRIMARY KEY CLUSTERED 
(
	[ScheduleKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [NFLDB].[ScheduleDefinition]    Script Date: 1/25/2018 4:45:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [NFLDB].[ScheduleDefinition](
	[ScheduleDefinitionKey] [int] IDENTITY(1,1) NOT NULL,
	[Week] [int] NOT NULL,
	[SeasonType] [varchar](4) NOT NULL,
	[DESCRIPTION] [varchar](20) NOT NULL,
 CONSTRAINT [PK_ScheduleDefinition] PRIMARY KEY CLUSTERED 
(
	[ScheduleDefinitionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  StoredProcedure [dbo].[bulkloaddrive]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[bulkloaddrive] @filePath nvarchar(100) = NULL, @fileName nvarchar(100) = NULL, @eid nvarchar(12) = NULL

AS
--Delete all where same records exsit 
DECLARE @bulkcmd AS VARCHAR(max)

SET @bulkcmd = 
'DELETE FROM LandNFL.drive where eid='''+@eid+''';
BULK INSERT LandNFL.drive
FROM '''+ @filePath +  @fileName + '''
WITH(
        DATA_SOURCE = ''nflgenstorage'',
		FORMAT=''CSV'',
        FORMATFILE = ''gamedayshred/lib/fmt/drive.xml'',
        FORMATFILE_DATA_SOURCE = ''nflgenstorage''
    );'

EXEC (@bulkcmd)
--PRINT @bulkcmd




GO
/****** Object:  StoredProcedure [dbo].[bulkloaddrive_old]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[bulkloaddrive_old] @filePath nvarchar(100) = NULL, @fileName nvarchar(100) = NULL

AS
--Delete all where same records exsit 
DECLARE @bulkcmd AS VARCHAR(max)

SET @bulkcmd = 
'BULK INSERT LandNFL.drive
FROM '''+ @filePath +  @fileName + '''
WITH(
        DATA_SOURCE = ''nflgenstorage'',
		FIRSTROW = 4,
        FORMATFILE = ''gamedayshred/lib/fmt/drive.xml'',
        FORMATFILE_DATA_SOURCE = ''nflgenstorage''
    );'

EXEC (@bulkcmd)
--PRINT @bulkcmd




GO
/****** Object:  StoredProcedure [dbo].[bulkloadgame]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[bulkloadgame] @filePath nvarchar(100) = NULL, @fileName nvarchar(100) = NULL, @eid nvarchar(12) = NULL

AS
--Delete all where same records exsit 
DECLARE @bulkcmd AS VARCHAR(max)

SET @bulkcmd = 
'DELETE FROM LandNFL.game where eid='''+@eid+''';
BULK INSERT LandNFL.game
FROM '''+ @filePath +  @fileName + '''
WITH(
        DATA_SOURCE = ''nflgenstorage'',
		FORMAT=''CSV'',
        FORMATFILE = ''gamedayshred/lib/fmt/game.xml'',
        FORMATFILE_DATA_SOURCE = ''nflgenstorage''
    );'

EXEC (@bulkcmd)
--PRINT @bulkcmd





GO
/****** Object:  StoredProcedure [dbo].[bulkloadplay]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[bulkloadplay] @filePath nvarchar(100) = NULL, @fileName nvarchar(100) = NULL, @eid nvarchar(100) = NULL

AS
--Delete all where same records exsit 
DECLARE @bulkcmd AS VARCHAR(max)

SET @bulkcmd = 
'DELETE FROM LandNFL.play where eid='''+@eid+''';
BULK INSERT LandNFL.play
FROM '''+ @filePath +  @fileName + '''
WITH(
        DATA_SOURCE = ''nflgenstorage'',
		FORMAT=''CSV'',
        FORMATFILE = ''gamedayshred/lib/fmt/play.xml'',
        FORMATFILE_DATA_SOURCE = ''nflgenstorage''
    );'

EXEC (@bulkcmd)
--PRINT @bulkcmd





GO
/****** Object:  StoredProcedure [dbo].[bulkloadplayplayer]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[bulkloadplayplayer] @filePath nvarchar(100) = NULL, @fileName nvarchar(100) = NULL, @eid nvarchar(12) = NULL

AS
--Delete all where same records exsit 
DECLARE @bulkcmd AS VARCHAR(max)

SET @bulkcmd = 
'DELETE FROM LandNFL.playplayer where eid='''+@eid+''';
BULK INSERT LandNFL.playplayer
FROM '''+ @filePath +  @fileName + '''
WITH(
        DATA_SOURCE = ''nflgenstorage'',
		FORMAT=''CSV'',
        FORMATFILE = ''gamedayshred/lib/fmt/playplayer.xml'',
        FORMATFILE_DATA_SOURCE = ''nflgenstorage''
    );'

EXEC (@bulkcmd)
--PRINT @bulkcmd





GO
/****** Object:  StoredProcedure [dbo].[LogProcedure]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[LogProcedure]

@ProcID INT = NULL,
@TableName nvarchar(256) = NULL,
@RowCount INT = NULL,
@insert INT = NULL,
@update INT = NULL,
@delete INT = NULL,
@starttime DATETIMEOFFSET = NULL,
@isStart BIT = 1


AS

BEGIN

    ----------------------------------------------------------------------------------------------------
    --//  Process Values                                                  //--
    ----------------------------------------------------------------------------------------------------

    SET NOCOUNT ON;

    DECLARE @EndTime DATETIMEOFFSET;
    SET @EndTime = GETDATE();

    DECLARE @Duration INT;
    SET @Duration = DATEDIFF(SECOND, @starttime, @EndTime);

	DECLARE @ProcName NVARCHAR(300) = OBJECT_NAME(@ProcID),
	@SchemaName NVARCHAR(300)= OBJECT_SCHEMA_NAME(@ProcID);

	DECLARE @ProcessName NVARCHAR(300) = CASE WHEN @ProcName LIKE 'writelogproctest' THEN 'Test Proc'
											  WHEN @ProcName LIKE 'CDCProcess%'  THEN 'CDC'
											  WHEN @ProcName LIKE 'Process%' THEN 'Merge'
											  ELSE 'Unknown'
											  END
												




    ----------------------------------------------------------------------------------------------------
    --// Log initial information                                                                    //--
    ----------------------------------------------------------------------------------------------------
    IF @isStart = 1
    BEGIN
        INSERT INTO dbo.ProcedureLog
        (
            ProcedureName,
            ProcessName,
            SchemaName,
            TableName,
            StartTime
        )
        VALUES
        (   @ProcName,    -- ProcedureName - varchar(300)
            @ProcessName, -- ProcessName - nvarchar(256)
            @SchemaName,  -- SchemaName - nvarchar(256)
            @TableName,   -- TableName - nvarchar(256)
            @starttime    -- StartTime - datetime
        );

    END;


    ----------------------------------------------------------------------------------------------------
    --// Log completing information                                                                 //--
    ----------------------------------------------------------------------------------------------------

    IF @isStart = 0
    BEGIN
        UPDATE dbo.ProcedureLog
        SET RecordsReceived = @RowCount,
            RecordsInserted = @insert,
            RecordsUpdated = @update,
            RecordsDeleted = @delete,
            EndTime = @EndTime,
            Duration = @Duration
        WHERE ProcedureName = @ProcName
              AND StartTime = @starttime;
    END;


----------------------------------------------------------------------------------------------------
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_generate_merge]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Turn system object marking on

CREATE PROC [dbo].[sp_generate_merge]
(
 @table_name varchar(776), -- The table/view for which the MERGE statement will be generated using the existing data
 @target_table varchar(776) = NULL, -- Use this parameter to specify a different table name into which the data will be inserted/updated/deleted
 @from varchar(800) = NULL, -- Use this parameter to filter the rows based on a filter condition (using WHERE)
 @include_timestamp bit = 0, -- Specify 1 for this parameter, if you want to include the TIMESTAMP/ROWVERSION column's data in the MERGE statement
 @debug_mode bit = 0, -- If @debug_mode is set to 1, the SQL statements constructed by this procedure will be printed for later examination
 @schema varchar(64) = NULL, -- Use this parameter if you are not the owner of the table
 @srcSchema VARCHAR(64) = NULL,	-- source schema for merge 
 @ommit_images bit = 0, -- Use this parameter to generate MERGE statement by omitting the 'image' columns
 @ommit_identity bit = 0, -- Use this parameter to ommit the identity columns
 @top int = NULL, -- Use this parameter to generate a MERGE statement only for the TOP n rows
 @cols_to_include varchar(8000) = NULL, -- List of columns to be included in the MERGE statement
 @cols_to_exclude varchar(8000) = NULL, -- List of columns to be excluded from the MERGE statement
 @update_only_if_changed bit = 1, -- When 1, only performs an UPDATE operation if an included column in a matched row has changed.
 @delete_if_not_matched bit = 1, -- When 1, deletes unmatched source rows from target, when 0 source rows will only be used to update existing rows or insert new.
 @disable_constraints bit = 0, -- When 1, disables foreign key constraints and enables them after the MERGE statement
 @ommit_computed_cols bit = 0, -- When 1, computed columns will not be included in the MERGE statement
 @include_use_db bit = 1, -- When 1, includes a USE [DatabaseName] statement at the beginning of the generated batch
 @results_to_text bit = 0, -- When 1, outputs results to grid/messages window. When 0, outputs MERGE statement in an XML fragment.
 @include_rowsaffected bit = 1, -- When 1, a section is added to the end of the batch which outputs rows affected by the MERGE
 @nologo bit = 0, -- When 1, the "About" comment is suppressed from output
 @batch_separator VARCHAR(50) = ';' -- Batch separator to use
)
AS
BEGIN

/***********************************************************************************************************
Procedure: sp_generate_merge (Version 0.93)
 (Adapted by Daniel Nolan for SQL Server 2008/2012)

Adapted from: sp_generate_inserts (Build 22) 
 (Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.)

Purpose: To generate a MERGE statement from existing data, which will INSERT/UPDATE/DELETE data based
 on matching primary key values in the source/target table.
 
 The generated statements can be executed to replicate the data in some other location.
 
 Typical use cases:
 * Generate statements for static data tables, store the .SQL file in source control and use 
 it as part of your Dev/Test/Prod deployment. The generated statements are re-runnable, so 
 you can make changes to the file and migrate those changes between environments.
 
 * Generate statements from your Production tables and then run those statements in your 
 Dev/Test environments. Schedule this as part of a SQL Job to keep all of your environments 
 in-sync.
 
 * Enter test data into your Dev environment, and then generate statements from the Dev
 tables so that you can always reproduce your test database with valid sample data.
 

Written by: Narayana Vyas Kondreddi
 http://vyaskn.tripod.com

 Daniel Nolan
 http://danere.com
 @dan3r3

Acknowledgements (sp_generate_merge):
 Nathan Skerl -- StackOverflow answer that provided a workaround for the output truncation problem
 http://stackoverflow.com/a/10489767/266882

 Bill Gibson -- Blog that detailed the static data table use case; the inspiration for this proc
 http://blogs.msdn.com/b/ssdt/archive/2012/02/02/including-data-in-an-sql-server-database-project.aspx
 
 Bill Graziano -- Blog that provided the groundwork for MERGE statement generation
 http://weblogs.sqlteam.com/billg/archive/2011/02/15/generate-merge-statements-from-a-table.aspx 

Acknowledgements (sp_generate_inserts):
 Divya Kalra -- For beta testing
 Mark Charsley -- For reporting a problem with scripting uniqueidentifier columns with NULL values
 Artur Zeygman -- For helping me simplify a bit of code for handling non-dbo owned tables
 Joris Laperre -- For reporting a regression bug in handling text/ntext columns

Tested on: SQL Server 2008 (10.50.1600), SQL Server 2012 (11.0.2100)

Date created: January 17th 2001 21:52 GMT
Modified: May 1st 2002 19:50 GMT
Last Modified: September 27th 2012 10:00 AEDT

Email: dan@danere.com, vyaskn@hotmail.com

NOTE: This procedure may not work with tables with a large number of columns (> 500).
 Results can be unpredictable with huge text columns or SQL Server 2000's sql_variant data types
 IMPORTANT: This procedure has not been extensively tested with international data (Extended characters or Unicode). If needed
 you might want to convert the datatypes of character variables in this procedure to their respective unicode counterparts
 like nchar and nvarchar

Get Started: Ensure that your SQL client is configured to send results to grid (default SSMS behaviour).
This ensures that the generated MERGE statement can be output in full, getting around SSMS's 4000 nchar limit.
After running this proc, click the hyperlink within the single row returned to copy the generated MERGE statement.

Example 1: To generate a MERGE statement for table 'titles':
 
 EXEC sp_generate_merge 'titles'

Example 2: To generate a MERGE statement for 'titlesCopy' table from 'titles' table:

 EXEC sp_generate_merge 'titles', 'titlesCopy'

Example 3: To generate a MERGE statement for table 'titles' that will unconditionally UPDATE matching rows 
 (ie. not perform a "has data changed?" check prior to going ahead with an UPDATE):
 
 EXEC sp_generate_merge 'titles', @update_only_if_changed = 0

Example 4: To generate a MERGE statement for 'titles' table for only those titles 
 which contain the word 'Computer' in them:
 NOTE: Do not complicate the FROM or WHERE clause here. It's assumed that you are good with T-SQL if you are using this parameter

 EXEC sp_generate_merge 'titles', @from = "from titles where title like '%Computer%'"

Example 5: To specify that you want to include TIMESTAMP column's data as well in the MERGE statement:
 (By default TIMESTAMP column's data is not scripted)

 EXEC sp_generate_merge 'titles', @include_timestamp = 1

Example 6: To print the debug information:

 EXEC sp_generate_merge 'titles', @debug_mode = 1

Example 7: If the table is in a different schema to the default, use @schema parameter to specify the schema name
 To use this option, you must have SELECT permissions on that table

 EXEC sp_generate_merge 'Nickstable', @schema = 'Nick'

Example 8: To generate a MERGE statement for the rest of the columns excluding images

 EXEC sp_generate_merge 'imgtable', @ommit_images = 1

Example 9: To generate a MERGE statement excluding (omitting) IDENTITY columns:
 (By default IDENTITY columns are included in the MERGE statement)

 EXEC sp_generate_merge 'mytable', @ommit_identity = 1

Example 10: To generate a MERGE statement for the TOP 10 rows in the table:
 
 EXEC sp_generate_merge 'mytable', @top = 10

Example 11: To generate a MERGE statement with only those columns you want:
 
 EXEC sp_generate_merge 'titles', @cols_to_include = "'title','title_id','au_id'"

Example 12: To generate a MERGE statement by omitting certain columns:
 
 EXEC sp_generate_merge 'titles', @cols_to_exclude = "'title','title_id','au_id'"

Example 13: To avoid checking the foreign key constraints while loading data with a MERGE statement:
 
 EXEC sp_generate_merge 'titles', @disable_constraints = 1

Example 14: To exclude computed columns from the MERGE statement:

 EXEC sp_generate_merge 'MyTable', @ommit_computed_cols = 1
 
***********************************************************************************************************/

SET NOCOUNT ON


--Making sure user only uses either @cols_to_include or @cols_to_exclude
IF ((@cols_to_include IS NOT NULL) AND (@cols_to_exclude IS NOT NULL))
 BEGIN
 RAISERROR('Use either @cols_to_include or @cols_to_exclude. Do not use both the parameters at once',16,1)
 RETURN -1 --Failure. Reason: Both @cols_to_include and @cols_to_exclude parameters are specified
 END


--Making sure the @cols_to_include and @cols_to_exclude parameters are receiving values in proper format
IF ((@cols_to_include IS NOT NULL) AND (PATINDEX('''%''',@cols_to_include) = 0))
 BEGIN
 RAISERROR('Invalid use of @cols_to_include property',16,1)
 PRINT 'Specify column names surrounded by single quotes and separated by commas'
 PRINT 'Eg: EXEC sp_generate_merge titles, @cols_to_include = "''title_id'',''title''"'
 RETURN -1 --Failure. Reason: Invalid use of @cols_to_include property
 END

IF ((@cols_to_exclude IS NOT NULL) AND (PATINDEX('''%''',@cols_to_exclude) = 0))
 BEGIN
 RAISERROR('Invalid use of @cols_to_exclude property',16,1)
 PRINT 'Specify column names surrounded by single quotes and separated by commas'
 PRINT 'Eg: EXEC sp_generate_merge titles, @cols_to_exclude = "''title_id'',''title''"'
 RETURN -1 --Failure. Reason: Invalid use of @cols_to_exclude property
 END


--Checking to see if the database name is specified along wih the table name
--Your database context should be local to the table for which you want to generate a MERGE statement
--specifying the database name is not allowed
IF (PARSENAME(@table_name,3)) IS NOT NULL
 BEGIN
 RAISERROR('Do not specify the database name. Be in the required database and just specify the table name.',16,1)
 RETURN -1 --Failure. Reason: Database name is specified along with the table name, which is not allowed
 END


--Checking for the existence of 'user table' or 'view'
--This procedure is not written to work on system tables
--To script the data in system tables, just create a view on the system tables and script the view instead
IF @schema IS NULL
 BEGIN
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table_name AND (TABLE_TYPE = 'BASE TABLE' OR TABLE_TYPE = 'VIEW') AND TABLE_SCHEMA = SCHEMA_NAME())
 BEGIN
 RAISERROR('User table or view not found.',16,1)
 PRINT 'You may see this error if the specified table is not in your default schema (' + SCHEMA_NAME() + '). In that case use @schema parameter to specify the schema name.'
 PRINT 'Make sure you have SELECT permission on that table or view.'
 RETURN -1 --Failure. Reason: There is no user table or view with this name
 END
 END
ELSE
 BEGIN
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table_name AND (TABLE_TYPE = 'BASE TABLE' OR TABLE_TYPE = 'VIEW') AND TABLE_SCHEMA = @schema)
 BEGIN
 RAISERROR('User table or view not found.',16,1)
 PRINT 'Make sure you have SELECT permission on that table or view.'
 RETURN -1 --Failure. Reason: There is no user table or view with this name 
 END
 END


--Variable declarations
DECLARE @Column_ID int, 
 @Column_List varchar(max), 
 @Column_List_For_Update varchar(max), 
 @Column_List_For_Check varchar(max), 
 @Column_Name varchar(128), 
 @Column_Name_Unquoted varchar(128), 
 @Data_Type varchar(128), 
 @Actual_Values nvarchar(max), --This is the string that will be finally executed to generate a MERGE statement
 @IDN varchar(128), --Will contain the IDENTITY column's name in the table
 @Target_Table_For_Output varchar(776),
 @Source_Table_Qualified varchar(776)
 
 

--Variable Initialization
SET @IDN = ''
SET @Column_ID = 0
SET @Column_Name = ''
SET @Column_Name_Unquoted = ''
SET @Column_List = ''
SET @Column_List_For_Update = ''
SET @Column_List_For_Check = ''
SET @Actual_Values = ''

--Variable Defaults
IF @schema IS NULL
 BEGIN
 SET @Target_Table_For_Output = QUOTENAME(COALESCE(@target_table, @table_name))
 END
ELSE
 BEGIN
 SET @Target_Table_For_Output = QUOTENAME(@schema) + '.' + QUOTENAME(COALESCE(@target_table, @table_name))
 END

SET @Source_Table_Qualified

 = QUOTENAME(COALESCE(@srcSchema,SCHEMA_NAME())) + '.' + QUOTENAME(@table_name)

--To get the first column's ID
SELECT @Column_ID = MIN(ORDINAL_POSITION) 
FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
WHERE TABLE_NAME = @table_name
AND TABLE_SCHEMA = COALESCE(@schema, SCHEMA_NAME())


--Loop through all the columns of the table, to get the column names and their data types
WHILE @Column_ID IS NOT NULL
 BEGIN
 SELECT @Column_Name = QUOTENAME(COLUMN_NAME), 
 @Column_Name_Unquoted = COLUMN_NAME,
 @Data_Type = DATA_TYPE 
 FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
 WHERE ORDINAL_POSITION = @Column_ID
 AND TABLE_NAME = @table_name
 AND TABLE_SCHEMA = COALESCE(@schema, SCHEMA_NAME())

 IF @cols_to_include IS NOT NULL --Selecting only user specified columns
 BEGIN
 IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_include) = 0 
 BEGIN
 GOTO SKIP_LOOP
 END
 END

 IF @cols_to_exclude IS NOT NULL --Selecting only user specified columns
 BEGIN
 IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_exclude) <> 0 
 BEGIN
 GOTO SKIP_LOOP
 END
 END

 --Making sure to output SET IDENTITY_INSERT ON/OFF in case the table has an IDENTITY column
 IF (SELECT COLUMNPROPERTY( OBJECT_ID(@Source_Table_Qualified),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsIdentity')) = 1 
 BEGIN
 IF @ommit_identity = 0 --Determing whether to include or exclude the IDENTITY column
 SET @IDN = @Column_Name
 ELSE
 GOTO SKIP_LOOP 
 END
 
 --Making sure whether to output computed columns or not
 IF @ommit_computed_cols = 1
 BEGIN
 IF (SELECT COLUMNPROPERTY( OBJECT_ID(@Source_Table_Qualified),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsComputed')) = 1 
 BEGIN
 GOTO SKIP_LOOP 
 END
 END
 
 --Tables with columns of IMAGE data type are not supported for obvious reasons
 IF(@Data_Type in ('image'))
 BEGIN
 IF (@ommit_images = 0)
 BEGIN
 RAISERROR('Tables with image columns are not supported.',16,1)
 PRINT 'Use @ommit_images = 1 parameter to generate a MERGE for the rest of the columns.'
 RETURN -1 --Failure. Reason: There is a column with image data type
 END
 ELSE
 BEGIN
 GOTO SKIP_LOOP
 END
 END

 --Determining the data type of the column and depending on the data type, the VALUES part of
 --the MERGE statement is generated. Care is taken to handle columns with NULL values. Also
 --making sure, not to lose any data from flot, real, money, smallmomey, datetime columns
 SET @Actual_Values = @Actual_Values +
 CASE 
 WHEN @Data_Type IN ('char','nchar') 
 THEN 
 'COALESCE(''N'''''' + REPLACE(RTRIM(' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')'
 WHEN @Data_Type IN ('varchar','nvarchar') 
 THEN 
 'COALESCE(''N'''''' + REPLACE(' + @Column_Name + ','''''''','''''''''''')+'''''''',''NULL'')'
 WHEN @Data_Type IN ('datetime','smalldatetime','datetime2','date') 
 THEN 
 'COALESCE('''''''' + RTRIM(CONVERT(char,' + @Column_Name + ',127))+'''''''',''NULL'')'
 WHEN @Data_Type IN ('uniqueidentifier') 
 THEN 
 'COALESCE(''N'''''' + REPLACE(CONVERT(char(36),RTRIM(' + @Column_Name + ')),'''''''','''''''''''')+'''''''',''NULL'')'
 WHEN @Data_Type IN ('text') 
 THEN 
 'COALESCE(''N'''''' + REPLACE(CONVERT(varchar(max),' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')' 
 WHEN @Data_Type IN ('ntext') 
 THEN 
 'COALESCE('''''''' + REPLACE(CONVERT(nvarchar(max),' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')' 
 WHEN @Data_Type IN ('xml') 
 THEN 
 'COALESCE('''''''' + REPLACE(CONVERT(nvarchar(max),' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')' 
 WHEN @Data_Type IN ('binary','varbinary') 
 THEN 
 'COALESCE(RTRIM(CONVERT(varchar(max),' + @Column_Name + ', 1))),''NULL'')' 
 WHEN @Data_Type IN ('timestamp','rowversion') 
 THEN 
 CASE 
 WHEN @include_timestamp = 0 
 THEN 
 '''DEFAULT''' 
 ELSE 
 'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')' 
 END
 WHEN @Data_Type IN ('float','real','money','smallmoney')
 THEN
 'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' + @Column_Name + ',2)' + ')),''NULL'')' 
 WHEN @Data_Type IN ('hierarchyid')
 THEN 
  'COALESCE(''hierarchyid::Parse(''+'''''''' + LTRIM(RTRIM(' + 'CONVERT(char, ' + @Column_Name + ')' + '))+''''''''+'')'',''NULL'')' 
 ELSE 
 'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' + @Column_Name + ')' + ')),''NULL'')' 
 END + '+' + ''',''' + ' + '
 
 --Generating the column list for the MERGE statement
 SET @Column_List = @Column_List + @Column_Name + ',' 
 
 --Don't update Primary Key or Identity columns
 IF NOT EXISTS(
 SELECT 1
 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
 INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
 WHERE pk.TABLE_NAME = @table_name
 AND pk.TABLE_SCHEMA = COALESCE(@schema, SCHEMA_NAME())
 AND CONSTRAINT_TYPE = 'PRIMARY KEY'
 AND c.TABLE_NAME = pk.TABLE_NAME
 AND c.TABLE_SCHEMA = pk.TABLE_SCHEMA
 AND c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME
 AND c.COLUMN_NAME = @Column_Name_Unquoted 
 )
 BEGIN
 SET @Column_List_For_Update = @Column_List_For_Update + @Column_Name + ' = Source.' + @Column_Name + ', 
  ' 
 SET @Column_List_For_Check = @Column_List_For_Check +
 CASE @Data_Type 
 WHEN 'text' THEN CHAR(10) + CHAR(9) + 'NULLIF(CAST(Source.' + @Column_Name + ' AS VARCHAR(MAX)), CAST(Target.' + @Column_Name + ' AS VARCHAR(MAX))) IS NOT NULL OR NULLIF(CAST(Target.' + @Column_Name + ' AS VARCHAR(MAX)), CAST(Source.' + @Column_Name + ' AS VARCHAR(MAX))) IS NOT NULL OR '
 WHEN 'ntext' THEN CHAR(10) + CHAR(9) + 'NULLIF(CAST(Source.' + @Column_Name + ' AS NVARCHAR(MAX)), CAST(Target.' + @Column_Name + ' AS NVARCHAR(MAX))) IS NOT NULL OR NULLIF(CAST(Target.' + @Column_Name + ' AS NVARCHAR(MAX)), CAST(Source.' + @Column_Name + ' AS NVARCHAR(MAX))) IS NOT NULL OR ' 
 ELSE CHAR(10) + CHAR(9) + 'NULLIF(Source.' + @Column_Name + ', Target.' + @Column_Name + ') IS NOT NULL OR NULLIF(Target.' + @Column_Name + ', Source.' + @Column_Name + ') IS NOT NULL OR '
 END 
 END

 SKIP_LOOP: --The label used in GOTO

 SELECT @Column_ID = MIN(ORDINAL_POSITION) 
 FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK) 
 WHERE TABLE_NAME = @table_name
 AND TABLE_SCHEMA = COALESCE(@schema, SCHEMA_NAME())
 AND ORDINAL_POSITION > @Column_ID

 END --Loop ends here!


--To get rid of the extra characters that got concatenated during the last run through the loop
IF LEN(@Column_List_For_Update) <> 0
 BEGIN
 SET @Column_List_For_Update = ' ' + LEFT(@Column_List_For_Update,len(@Column_List_For_Update) - 4)
 END

IF LEN(@Column_List_For_Check) <> 0
 BEGIN
 SET @Column_List_For_Check = LEFT(@Column_List_For_Check,len(@Column_List_For_Check) - 3)
 END

SET @Actual_Values = LEFT(@Actual_Values,len(@Actual_Values) - 6)

SET @Column_List = LEFT(@Column_List,len(@Column_List) - 1)
IF LEN(LTRIM(@Column_List)) = 0
 BEGIN
 RAISERROR('No columns to select. There should at least be one column to generate the output',16,1)
 RETURN -1 --Failure. Reason: Looks like all the columns are ommitted using the @cols_to_exclude parameter
 END


--Get the join columns ----------------------------------------------------------
DECLARE @PK_column_list VARCHAR(8000)
DECLARE @PK_column_joins VARCHAR(8000)
SET @PK_column_list = ''
SET @PK_column_joins = ''

SELECT @PK_column_list = @PK_column_list + '[' + c.COLUMN_NAME + '], '
, @PK_column_joins = @PK_column_joins + 'Target.[' + c.COLUMN_NAME + '] = Source.[' + c.COLUMN_NAME + '] AND '
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
WHERE pk.TABLE_NAME = @table_name
AND pk.TABLE_SCHEMA = COALESCE(@schema, SCHEMA_NAME())
AND CONSTRAINT_TYPE = 'PRIMARY KEY'
AND c.TABLE_NAME = pk.TABLE_NAME
AND c.TABLE_SCHEMA = pk.TABLE_SCHEMA
AND c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME

IF IsNull(@PK_column_list, '') = '' 
 BEGIN
 RAISERROR('Table has no primary keys. There should at least be one column in order to have a valid join.',16,1)
 RETURN -1 --Failure. Reason: looks like table doesn't have any primary keys
 END

SET @PK_column_list = LEFT(@PK_column_list, LEN(@PK_column_list) -1)
SET @PK_column_joins = LEFT(@PK_column_joins, LEN(@PK_column_joins) -4)


--Forming the final string that will be executed, to output the a MERGE statement
SET @Actual_Values = 
 'SELECT ' + 
 CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END + 
 '''' + 
 ' '' + CASE WHEN ROW_NUMBER() OVER (ORDER BY ' + @PK_column_list + ') = 1 THEN '' '' ELSE '','' END + ''(''+ ' + @Actual_Values + '+'')''' + ' ' + 
 COALESCE(@from,' FROM ' + @Source_Table_Qualified + ' (NOLOCK) ORDER BY ' + @PK_column_list)

 DECLARE @output VARCHAR(MAX) = ''
 DECLARE @b CHAR(1) = CHAR(13)

--Determining whether to ouput any debug information
IF @debug_mode =1
 BEGIN
 SET @output += @b + '/*****START OF DEBUG INFORMATION*****'
 SET @output += @b + ''
 SET @output += @b + 'The primary key column list:'
 SET @output += @b + @PK_column_list
 SET @output += @b + ''
 SET @output += @b + 'The INSERT column list:'
 SET @output += @b + @Column_List
 SET @output += @b + ''
 SET @output += @b + 'The UPDATE column list:'
 SET @output += @b + @Column_List_For_Update
 SET @output += @b + ''
 SET @output += @b + 'The SELECT statement executed to generate the MERGE:'
 SET @output += @b + @Actual_Values
 SET @output += @b + ''
 SET @output += @b + '*****END OF DEBUG INFORMATION*****/'
 SET @output += @b + ''
 END
 
IF (@include_use_db = 1)
BEGIN
	SET @output +=      'USE ' + DB_NAME()
	SET @output += @b + @batch_separator
	SET @output += @b + @b
END

IF (@nologo = 0)
BEGIN
 SET @output += @b + '--MERGE generated by ''sp_generate_merge'' stored procedure, Version 0.93'
 SET @output += @b + '--Originally by Vyas (http://vyaskn.tripod.com): sp_generate_inserts (build 22)'
 SET @output += @b + '--Adapted for SQL Server 2008/2012 by Daniel Nolan (http://danere.com)'
 SET @output += @b + ''
END

IF (@include_rowsaffected = 1) -- If the caller has elected not to include the "rows affected" section, let MERGE output the row count as it is executed.
 SET @output += @b + 'SET NOCOUNT ON'
 SET @output += @b + ''


--Determining whether to print IDENTITY_INSERT or not
IF (LEN(@IDN) <> 0)
 BEGIN
 SET @output += @b + 'SET IDENTITY_INSERT ' + @Target_Table_For_Output + ' ON'
 SET @output += @b + ''
 END


--Temporarily disable constraints on the target table
IF @disable_constraints = 1 AND (OBJECT_ID(@Source_Table_Qualified, 'U') IS NOT NULL)
 BEGIN
 SET @output += @b + 'ALTER TABLE ' + @Target_Table_For_Output + ' NOCHECK CONSTRAINT ALL' --Code to disable constraints temporarily
 END


--Add record keeping timestamps to statement 
SET @output += @b + 'DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));' 
SET @output += @b + 'DECLARE @datetime DATETIMEOFFSET = GETDATE(); '

-- Write start to log 
SET @output += @b + 'EXEC dbo.LogProcedure @ProcID =  @@PROCID, @TableName = '''+ @Target_Table_For_Output +''', @starttime = @datetime, @isStart = true'
SET @output += @b + @batch_separator

--Output the start of the MERGE statement, qualifying with the schema name only if the caller explicitly specified it
SET @output += @b + 'MERGE INTO ' + @Target_Table_For_Output + ' AS Target'
SET @output += @b + 'USING  ( '--VALUES'
SET @output += @b + 'Select ' + @Column_List 
SET @output += @b + ' From' + @Source_Table_Qualified

--All the hard work pays off here!!! You'll get your MERGE statement, when the next line executes!
--DECLARE @tab TABLE (ID INT NOT NULL PRIMARY KEY IDENTITY(1,1), val NVARCHAR(max));
--INSERT INTO @tab (val)
--EXEC (@Actual_Values)

--IF (SELECT COUNT(*) FROM @tab) <> 0 -- Ensure that rows were returned, otherwise the MERGE statement will get nullified.
--BEGIN
-- SET @output += CAST((SELECT @b + val FROM @tab ORDER BY ID FOR XML PATH('')) AS XML).value('.', 'VARCHAR(MAX)');
--END


--Output the columns to correspond with each of the values above--------------------
SET @output += @b + ') AS Source (' + @Column_List + ')'


--Output the join columns ----------------------------------------------------------
SET @output += @b + 'ON (' + @PK_column_joins + ')'


--When matched, perform an UPDATE on any metadata columns only (ie. not on PK)------
IF LEN(@Column_List_For_Update) <> 0
BEGIN
 SET @output += @b + 'WHEN MATCHED ' + CASE WHEN @update_only_if_changed = 1 THEN 'AND (' + @Column_List_For_Check + ' OR ' ELSE '' END 
 SET @output += @b + '  Target.deletets IS NOT NULL) THEN'
 SET @output += @b + ' UPDATE SET'
 SET @output += @b + '  ' + LTRIM(@Column_List_For_Update) + ','
 SET @output += @b + '   [modifyts] = @datetime,'
 SET @output += @b + '    deletets = NULL ' 
END


--When NOT matched by target, perform an INSERT------------------------------------
SET @output += @b + 'WHEN NOT MATCHED BY TARGET THEN';
SET @output += @b + ' INSERT(' + @Column_List + ',[createts],[modifyts],[deletets])'
SET @output += @b + ' VALUES(' + REPLACE(@Column_List, '[', 'Source.[') + ',@datetime,@datetime,NULL)'


--When NOT matched by source, DELETE the row
IF @delete_if_not_matched=1 BEGIN
 SET @output += @b + 'WHEN NOT MATCHED BY SOURCE AND Target.deletets IS NULL AND Target.eid IN  (SELECT DISTINCT eid FROM ' +  @Source_Table_Qualified   +')  THEN  '
 --SET @output += @b + ' DELETE'
 SET @output += @b + '  UPDATE SET	deletets = @datetime'
 SET @output += @b + 'OUTPUT $action INTO @SummaryOfChanges'
END;
--SET @output += @b + ';'
SET @output += @b + @batch_separator

--Display the number of affected rows to the user, or report if an error occurred---
IF @include_rowsaffected = 1
BEGIN
 SET @output += @b + 'DECLARE @mergeError int'
 SET @output += @b + ' , @mergeCount int'
 SET @output += @b + 'SELECT @mergeError = @@ERROR, @mergeCount = @@ROWCOUNT'
 SET @output += @b + 'IF @mergeError != 0'
 SET @output += @b + ' BEGIN'
 SET @output += @b + ' PRINT ''ERROR OCCURRED IN MERGE FOR ' + @Target_Table_For_Output + '. Rows affected: '' + CAST(@mergeCount AS VARCHAR(100)); -- SQL should always return zero rows affected';
 SET @output += @b + ' END'
 SET @output += @b + 'ELSE'
 SET @output += @b + ' BEGIN'
 SET @output += @b + ' PRINT ''' + @Target_Table_For_Output + ' rows affected by MERGE: '' + CAST(@mergeCount AS VARCHAR(100));';
 SET @output += @b + ' END'
 SET @output += @b + @batch_separator
 SET @output += @b + @b
END

--Log end and results---
 SET @output += @b + 'DECLARE @rowcount int = @mergeCount, '
 SET @output += @b + '		@insert INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = ''INSERT''), '
 SET @output += @b + '		@update INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = ''update''), '
 SET @output += @b + '		@delete INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = ''DELETE'')  '
 SET @output += @b + ' EXEC dbo.LogProcedure @ProcID = @@PROCID, @RowCount = @rowcount,@insert = @insert,@update = @update, @delete = @delete, @starttime = @datetime, @isStart = false'

 SET @output += @b + @batch_separator
 SET @output += @b + @b

--Re-enable the previously disabled constraints-------------------------------------
IF @disable_constraints = 1 AND (OBJECT_ID(@Source_Table_Qualified, 'U') IS NOT NULL)
 BEGIN
 SET @output +=      'ALTER TABLE ' + @Target_Table_For_Output + ' CHECK CONSTRAINT ALL' --Code to enable the previously disabled constraints
 SET @output += @b + @batch_separator
 SET @output += @b
 END


--Switch-off identity inserting------------------------------------------------------
IF (LEN(@IDN) <> 0)
 BEGIN
 SET @output +=      'SET IDENTITY_INSERT ' + @Target_Table_For_Output + ' OFF'
 SET @output += @b + @batch_separator
 SET @output += @b
 END

IF (@include_rowsaffected = 1)
BEGIN
 SET @output +=      'SET NOCOUNT OFF'
 SET @output += @b + @batch_separator
 SET @output += @b
END

SET @output += @b + ''
SET @output += @b + ''

IF @results_to_text = 1
BEGIN
	--output the statement to the Grid/Messages tab
	SELECT @output;
END
ELSE
BEGIN
	--output the statement as xml (to overcome SSMS 4000/8000 char limitation)
	SELECT [processing-instruction(x)]=@output FOR XML PATH(''),TYPE;
	PRINT 'MERGE statement has been wrapped in an XML fragment and output successfully.'
	PRINT 'Ensure you have Results to Grid enabled and then click the hyperlink to copy the statement within the fragment.'
	PRINT ''
	PRINT 'If you would prefer to have results output directly (without XML) specify @results_to_text = 1, however please'
	PRINT 'note that the results may be truncated by your SQL client to 4000 nchars.'
END

SET NOCOUNT OFF
RETURN 0 --Success. We are done!
END



GO
/****** Object:  StoredProcedure [LandNFL].[TruncateTables]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC  [LandNFL].[TruncateTables]

 AS 

TRUNCATE TABLE LandNFL.drive
TRUNCATE TABLE LandNFL.game
TRUNCATE TABLE LandNFL.play
TRUNCATE TABLE LandNFL.playplayer


GO
/****** Object:  StoredProcedure [MasterNFL].[CDCDrive]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--MERGE generated by 'sp_generate_merge' stored procedure, Version 0.93
--Originally by Vyas (http://vyaskn.tripod.com): sp_generate_inserts (build 22)
--Adapted for SQL Server 2008/2012 by Daniel Nolan (http://danere.com)
CREATE PROC [MasterNFL].[CDCDrive]
as

SET NOCOUNT ON

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));
DECLARE @datetime DATETIMEOFFSET = GETDATE(); 
EXEC dbo.LogProcedure @ProcID =  @@PROCID, @TableName = '[MasterNFL].[game]', @starttime = @datetime, @isStart = true
;
MERGE INTO [MasterNFL].[game] AS Target
USING  ( 
Select [eid],[home-abbr],[home-players],[away-to],[away-score-1],[away-score-2],[away-score-3],[away-score-4],[away-score-5],[away-score-T],[away-stats-team-totfd],[away-stats-team-pt],[away-stats-team-ptyds],[away-stats-team-trnovr],[away-stats-team-pyds],[away-stats-team-ryds],[away-stats-team-totyds],[away-stats-team-ptavg],[away-stats-team-pen],[away-stats-team-penyds],[away-stats-team-top],[away-abbr],[away-players],[home-to],[home-score-1],[home-score-2],[home-score-3],[home-score-4],[home-score-5],[home-score-T],[home-stats-team-totfd],[home-stats-team-pt],[home-stats-team-ptyds],[home-stats-team-trnovr],[home-stats-team-pyds],[home-stats-team-ryds],[home-stats-team-totyds],[home-stats-team-ptavg],[home-stats-team-pen],[home-stats-team-penyds],[home-stats-team-top]
 From[LandNFL].[game]
) AS Source ([eid],[home-abbr],[home-players],[away-to],[away-score-1],[away-score-2],[away-score-3],[away-score-4],[away-score-5],[away-score-T],[away-stats-team-totfd],[away-stats-team-pt],[away-stats-team-ptyds],[away-stats-team-trnovr],[away-stats-team-pyds],[away-stats-team-ryds],[away-stats-team-totyds],[away-stats-team-ptavg],[away-stats-team-pen],[away-stats-team-penyds],[away-stats-team-top],[away-abbr],[away-players],[home-to],[home-score-1],[home-score-2],[home-score-3],[home-score-4],[home-score-5],[home-score-T],[home-stats-team-totfd],[home-stats-team-pt],[home-stats-team-ptyds],[home-stats-team-trnovr],[home-stats-team-pyds],[home-stats-team-ryds],[home-stats-team-totyds],[home-stats-team-ptavg],[home-stats-team-pen],[home-stats-team-penyds],[home-stats-team-top])
ON (Target.[eid] = Source.[eid])
WHEN MATCHED AND (
	NULLIF(Source.[home-abbr], Target.[home-abbr]) IS NOT NULL OR NULLIF(Target.[home-abbr], Source.[home-abbr]) IS NOT NULL OR 
	NULLIF(Source.[home-players], Target.[home-players]) IS NOT NULL OR NULLIF(Target.[home-players], Source.[home-players]) IS NOT NULL OR 
	NULLIF(Source.[away-to], Target.[away-to]) IS NOT NULL OR NULLIF(Target.[away-to], Source.[away-to]) IS NOT NULL OR 
	NULLIF(Source.[away-score-1], Target.[away-score-1]) IS NOT NULL OR NULLIF(Target.[away-score-1], Source.[away-score-1]) IS NOT NULL OR 
	NULLIF(Source.[away-score-2], Target.[away-score-2]) IS NOT NULL OR NULLIF(Target.[away-score-2], Source.[away-score-2]) IS NOT NULL OR 
	NULLIF(Source.[away-score-3], Target.[away-score-3]) IS NOT NULL OR NULLIF(Target.[away-score-3], Source.[away-score-3]) IS NOT NULL OR 
	NULLIF(Source.[away-score-4], Target.[away-score-4]) IS NOT NULL OR NULLIF(Target.[away-score-4], Source.[away-score-4]) IS NOT NULL OR 
	NULLIF(Source.[away-score-5], Target.[away-score-5]) IS NOT NULL OR NULLIF(Target.[away-score-5], Source.[away-score-5]) IS NOT NULL OR 
	NULLIF(Source.[away-score-T], Target.[away-score-T]) IS NOT NULL OR NULLIF(Target.[away-score-T], Source.[away-score-T]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-totfd], Target.[away-stats-team-totfd]) IS NOT NULL OR NULLIF(Target.[away-stats-team-totfd], Source.[away-stats-team-totfd]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-pt], Target.[away-stats-team-pt]) IS NOT NULL OR NULLIF(Target.[away-stats-team-pt], Source.[away-stats-team-pt]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-ptyds], Target.[away-stats-team-ptyds]) IS NOT NULL OR NULLIF(Target.[away-stats-team-ptyds], Source.[away-stats-team-ptyds]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-trnovr], Target.[away-stats-team-trnovr]) IS NOT NULL OR NULLIF(Target.[away-stats-team-trnovr], Source.[away-stats-team-trnovr]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-pyds], Target.[away-stats-team-pyds]) IS NOT NULL OR NULLIF(Target.[away-stats-team-pyds], Source.[away-stats-team-pyds]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-ryds], Target.[away-stats-team-ryds]) IS NOT NULL OR NULLIF(Target.[away-stats-team-ryds], Source.[away-stats-team-ryds]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-totyds], Target.[away-stats-team-totyds]) IS NOT NULL OR NULLIF(Target.[away-stats-team-totyds], Source.[away-stats-team-totyds]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-ptavg], Target.[away-stats-team-ptavg]) IS NOT NULL OR NULLIF(Target.[away-stats-team-ptavg], Source.[away-stats-team-ptavg]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-pen], Target.[away-stats-team-pen]) IS NOT NULL OR NULLIF(Target.[away-stats-team-pen], Source.[away-stats-team-pen]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-penyds], Target.[away-stats-team-penyds]) IS NOT NULL OR NULLIF(Target.[away-stats-team-penyds], Source.[away-stats-team-penyds]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-top], Target.[away-stats-team-top]) IS NOT NULL OR NULLIF(Target.[away-stats-team-top], Source.[away-stats-team-top]) IS NOT NULL OR 
	NULLIF(Source.[away-abbr], Target.[away-abbr]) IS NOT NULL OR NULLIF(Target.[away-abbr], Source.[away-abbr]) IS NOT NULL OR 
	NULLIF(Source.[away-players], Target.[away-players]) IS NOT NULL OR NULLIF(Target.[away-players], Source.[away-players]) IS NOT NULL OR 
	NULLIF(Source.[home-to], Target.[home-to]) IS NOT NULL OR NULLIF(Target.[home-to], Source.[home-to]) IS NOT NULL OR 
	NULLIF(Source.[home-score-1], Target.[home-score-1]) IS NOT NULL OR NULLIF(Target.[home-score-1], Source.[home-score-1]) IS NOT NULL OR 
	NULLIF(Source.[home-score-2], Target.[home-score-2]) IS NOT NULL OR NULLIF(Target.[home-score-2], Source.[home-score-2]) IS NOT NULL OR 
	NULLIF(Source.[home-score-3], Target.[home-score-3]) IS NOT NULL OR NULLIF(Target.[home-score-3], Source.[home-score-3]) IS NOT NULL OR 
	NULLIF(Source.[home-score-4], Target.[home-score-4]) IS NOT NULL OR NULLIF(Target.[home-score-4], Source.[home-score-4]) IS NOT NULL OR 
	NULLIF(Source.[home-score-5], Target.[home-score-5]) IS NOT NULL OR NULLIF(Target.[home-score-5], Source.[home-score-5]) IS NOT NULL OR 
	NULLIF(Source.[home-score-T], Target.[home-score-T]) IS NOT NULL OR NULLIF(Target.[home-score-T], Source.[home-score-T]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-totfd], Target.[home-stats-team-totfd]) IS NOT NULL OR NULLIF(Target.[home-stats-team-totfd], Source.[home-stats-team-totfd]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-pt], Target.[home-stats-team-pt]) IS NOT NULL OR NULLIF(Target.[home-stats-team-pt], Source.[home-stats-team-pt]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-ptyds], Target.[home-stats-team-ptyds]) IS NOT NULL OR NULLIF(Target.[home-stats-team-ptyds], Source.[home-stats-team-ptyds]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-trnovr], Target.[home-stats-team-trnovr]) IS NOT NULL OR NULLIF(Target.[home-stats-team-trnovr], Source.[home-stats-team-trnovr]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-pyds], Target.[home-stats-team-pyds]) IS NOT NULL OR NULLIF(Target.[home-stats-team-pyds], Source.[home-stats-team-pyds]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-ryds], Target.[home-stats-team-ryds]) IS NOT NULL OR NULLIF(Target.[home-stats-team-ryds], Source.[home-stats-team-ryds]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-totyds], Target.[home-stats-team-totyds]) IS NOT NULL OR NULLIF(Target.[home-stats-team-totyds], Source.[home-stats-team-totyds]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-ptavg], Target.[home-stats-team-ptavg]) IS NOT NULL OR NULLIF(Target.[home-stats-team-ptavg], Source.[home-stats-team-ptavg]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-pen], Target.[home-stats-team-pen]) IS NOT NULL OR NULLIF(Target.[home-stats-team-pen], Source.[home-stats-team-pen]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-penyds], Target.[home-stats-team-penyds]) IS NOT NULL OR NULLIF(Target.[home-stats-team-penyds], Source.[home-stats-team-penyds]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-top], Target.[home-stats-team-top]) IS NOT NULL OR NULLIF(Target.[home-stats-team-top], Source.[home-stats-team-top]) IS NOT NULL OR 
  Target.deletets IS NOT NULL) THEN
 UPDATE SET
  [home-abbr] = Source.[home-abbr], 
  [home-players] = Source.[home-players], 
  [away-to] = Source.[away-to], 
  [away-score-1] = Source.[away-score-1], 
  [away-score-2] = Source.[away-score-2], 
  [away-score-3] = Source.[away-score-3], 
  [away-score-4] = Source.[away-score-4], 
  [away-score-5] = Source.[away-score-5], 
  [away-score-T] = Source.[away-score-T], 
  [away-stats-team-totfd] = Source.[away-stats-team-totfd], 
  [away-stats-team-pt] = Source.[away-stats-team-pt], 
  [away-stats-team-ptyds] = Source.[away-stats-team-ptyds], 
  [away-stats-team-trnovr] = Source.[away-stats-team-trnovr], 
  [away-stats-team-pyds] = Source.[away-stats-team-pyds], 
  [away-stats-team-ryds] = Source.[away-stats-team-ryds], 
  [away-stats-team-totyds] = Source.[away-stats-team-totyds], 
  [away-stats-team-ptavg] = Source.[away-stats-team-ptavg], 
  [away-stats-team-pen] = Source.[away-stats-team-pen], 
  [away-stats-team-penyds] = Source.[away-stats-team-penyds], 
  [away-stats-team-top] = Source.[away-stats-team-top], 
  [away-abbr] = Source.[away-abbr], 
  [away-players] = Source.[away-players], 
  [home-to] = Source.[home-to], 
  [home-score-1] = Source.[home-score-1], 
  [home-score-2] = Source.[home-score-2], 
  [home-score-3] = Source.[home-score-3], 
  [home-score-4] = Source.[home-score-4], 
  [home-score-5] = Source.[home-score-5], 
  [home-score-T] = Source.[home-score-T], 
  [home-stats-team-totfd] = Source.[home-stats-team-totfd], 
  [home-stats-team-pt] = Source.[home-stats-team-pt], 
  [home-stats-team-ptyds] = Source.[home-stats-team-ptyds], 
  [home-stats-team-trnovr] = Source.[home-stats-team-trnovr], 
  [home-stats-team-pyds] = Source.[home-stats-team-pyds], 
  [home-stats-team-ryds] = Source.[home-stats-team-ryds], 
  [home-stats-team-totyds] = Source.[home-stats-team-totyds], 
  [home-stats-team-ptavg] = Source.[home-stats-team-ptavg], 
  [home-stats-team-pen] = Source.[home-stats-team-pen], 
  [home-stats-team-penyds] = Source.[home-stats-team-penyds], 
  [home-stats-team-top] = Source.[home-stats-team-top],
   [modifyts] = @datetime,
    deletets = NULL 
WHEN NOT MATCHED BY TARGET THEN
 INSERT([eid],[home-abbr],[home-players],[away-to],[away-score-1],[away-score-2],[away-score-3],[away-score-4],[away-score-5],[away-score-T],[away-stats-team-totfd],[away-stats-team-pt],[away-stats-team-ptyds],[away-stats-team-trnovr],[away-stats-team-pyds],[away-stats-team-ryds],[away-stats-team-totyds],[away-stats-team-ptavg],[away-stats-team-pen],[away-stats-team-penyds],[away-stats-team-top],[away-abbr],[away-players],[home-to],[home-score-1],[home-score-2],[home-score-3],[home-score-4],[home-score-5],[home-score-T],[home-stats-team-totfd],[home-stats-team-pt],[home-stats-team-ptyds],[home-stats-team-trnovr],[home-stats-team-pyds],[home-stats-team-ryds],[home-stats-team-totyds],[home-stats-team-ptavg],[home-stats-team-pen],[home-stats-team-penyds],[home-stats-team-top],[createts],[modifyts],[deletets])
 VALUES(Source.[eid],Source.[home-abbr],Source.[home-players],Source.[away-to],Source.[away-score-1],Source.[away-score-2],Source.[away-score-3],Source.[away-score-4],Source.[away-score-5],Source.[away-score-T],Source.[away-stats-team-totfd],Source.[away-stats-team-pt],Source.[away-stats-team-ptyds],Source.[away-stats-team-trnovr],Source.[away-stats-team-pyds],Source.[away-stats-team-ryds],Source.[away-stats-team-totyds],Source.[away-stats-team-ptavg],Source.[away-stats-team-pen],Source.[away-stats-team-penyds],Source.[away-stats-team-top],Source.[away-abbr],Source.[away-players],Source.[home-to],Source.[home-score-1],Source.[home-score-2],Source.[home-score-3],Source.[home-score-4],Source.[home-score-5],Source.[home-score-T],Source.[home-stats-team-totfd],Source.[home-stats-team-pt],Source.[home-stats-team-ptyds],Source.[home-stats-team-trnovr],Source.[home-stats-team-pyds],Source.[home-stats-team-ryds],Source.[home-stats-team-totyds],Source.[home-stats-team-ptavg],Source.[home-stats-team-pen],Source.[home-stats-team-penyds],Source.[home-stats-team-top],@datetime,@datetime,NULL)
WHEN NOT MATCHED BY SOURCE AND Target.deletets IS NULL AND Target.eid IN  (SELECT DISTINCT eid FROM [LandNFL].[game])  THEN  
  UPDATE SET	deletets = @datetime
OUTPUT $action INTO @SummaryOfChanges
;
DECLARE @mergeError int
 , @mergeCount int
SELECT @mergeError = @@ERROR, @mergeCount = @@ROWCOUNT
IF @mergeError != 0
 BEGIN
 PRINT 'ERROR OCCURRED IN MERGE FOR [MasterNFL].[game]. Rows affected: ' + CAST(@mergeCount AS VARCHAR(100)); -- SQL should always return zero rows affected
 END
ELSE
 BEGIN
 PRINT '[MasterNFL].[game] rows affected by MERGE: ' + CAST(@mergeCount AS VARCHAR(100));
 END
;


DECLARE @rowcount int = @mergeCount, 
		@insert INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'INSERT'), 
		@update INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'update'), 
		@delete INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'DELETE')  
 EXEC dbo.LogProcedure @ProcID = @@PROCID, @RowCount = @rowcount,@insert = @insert,@update = @update, @delete = @delete, @starttime = @datetime, @isStart = false
;

SET NOCOUNT OFF
;

GO
/****** Object:  StoredProcedure [MasterNFL].[CDCgame]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [MasterNFL].[CDCgame]
as
--MERGE generated by 'sp_generate_merge' stored procedure, Version 0.93
--Originally by Vyas (http://vyaskn.tripod.com): sp_generate_inserts (build 22)
--Adapted for SQL Server 2008/2012 by Daniel Nolan (http://danere.com)

SET NOCOUNT ON

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));
DECLARE @datetime DATETIMEOFFSET = GETDATE(); 
EXEC dbo.LogProcedure @ProcID =  @@PROCID, @TableName = '[MasterNFL].[game]', @starttime = @datetime, @isStart = true
;
MERGE INTO [MasterNFL].[game] AS Target
USING  ( 
Select [eid],[home-abbr],[home-players],[away-to],[away-stats-team-totfd],[away-stats-team-pt],[away-stats-team-ptyds],[away-stats-team-trnovr],[away-stats-team-pyds],[away-stats-team-ryds],[away-stats-team-totyds],[away-stats-team-ptavg],[away-stats-team-pen],[away-stats-team-penyds],[away-stats-team-top],[away-abbr],[away-players],[home-to],[home-stats-team-totfd],[home-stats-team-pt],[home-stats-team-ptyds],[home-stats-team-trnovr],[home-stats-team-pyds],[home-stats-team-ryds],[home-stats-team-totyds],[home-stats-team-ptavg],[home-stats-team-pen],[home-stats-team-penyds],[home-stats-team-top]
 From[LandNFL].[game]
) AS Source ([eid],[home-abbr],[home-players],[away-to],[away-stats-team-totfd],[away-stats-team-pt],[away-stats-team-ptyds],[away-stats-team-trnovr],[away-stats-team-pyds],[away-stats-team-ryds],[away-stats-team-totyds],[away-stats-team-ptavg],[away-stats-team-pen],[away-stats-team-penyds],[away-stats-team-top],[away-abbr],[away-players],[home-to],[home-stats-team-totfd],[home-stats-team-pt],[home-stats-team-ptyds],[home-stats-team-trnovr],[home-stats-team-pyds],[home-stats-team-ryds],[home-stats-team-totyds],[home-stats-team-ptavg],[home-stats-team-pen],[home-stats-team-penyds],[home-stats-team-top])
ON (Target.[eid] = Source.[eid])
WHEN MATCHED AND (
	NULLIF(Source.[home-abbr], Target.[home-abbr]) IS NOT NULL OR NULLIF(Target.[home-abbr], Source.[home-abbr]) IS NOT NULL OR 
	NULLIF(Source.[home-players], Target.[home-players]) IS NOT NULL OR NULLIF(Target.[home-players], Source.[home-players]) IS NOT NULL OR 
	NULLIF(Source.[away-to], Target.[away-to]) IS NOT NULL OR NULLIF(Target.[away-to], Source.[away-to]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-totfd], Target.[away-stats-team-totfd]) IS NOT NULL OR NULLIF(Target.[away-stats-team-totfd], Source.[away-stats-team-totfd]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-pt], Target.[away-stats-team-pt]) IS NOT NULL OR NULLIF(Target.[away-stats-team-pt], Source.[away-stats-team-pt]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-ptyds], Target.[away-stats-team-ptyds]) IS NOT NULL OR NULLIF(Target.[away-stats-team-ptyds], Source.[away-stats-team-ptyds]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-trnovr], Target.[away-stats-team-trnovr]) IS NOT NULL OR NULLIF(Target.[away-stats-team-trnovr], Source.[away-stats-team-trnovr]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-pyds], Target.[away-stats-team-pyds]) IS NOT NULL OR NULLIF(Target.[away-stats-team-pyds], Source.[away-stats-team-pyds]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-ryds], Target.[away-stats-team-ryds]) IS NOT NULL OR NULLIF(Target.[away-stats-team-ryds], Source.[away-stats-team-ryds]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-totyds], Target.[away-stats-team-totyds]) IS NOT NULL OR NULLIF(Target.[away-stats-team-totyds], Source.[away-stats-team-totyds]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-ptavg], Target.[away-stats-team-ptavg]) IS NOT NULL OR NULLIF(Target.[away-stats-team-ptavg], Source.[away-stats-team-ptavg]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-pen], Target.[away-stats-team-pen]) IS NOT NULL OR NULLIF(Target.[away-stats-team-pen], Source.[away-stats-team-pen]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-penyds], Target.[away-stats-team-penyds]) IS NOT NULL OR NULLIF(Target.[away-stats-team-penyds], Source.[away-stats-team-penyds]) IS NOT NULL OR 
	NULLIF(Source.[away-stats-team-top], Target.[away-stats-team-top]) IS NOT NULL OR NULLIF(Target.[away-stats-team-top], Source.[away-stats-team-top]) IS NOT NULL OR 
	NULLIF(Source.[away-abbr], Target.[away-abbr]) IS NOT NULL OR NULLIF(Target.[away-abbr], Source.[away-abbr]) IS NOT NULL OR 
	NULLIF(Source.[away-players], Target.[away-players]) IS NOT NULL OR NULLIF(Target.[away-players], Source.[away-players]) IS NOT NULL OR 
	NULLIF(Source.[home-to], Target.[home-to]) IS NOT NULL OR NULLIF(Target.[home-to], Source.[home-to]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-totfd], Target.[home-stats-team-totfd]) IS NOT NULL OR NULLIF(Target.[home-stats-team-totfd], Source.[home-stats-team-totfd]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-pt], Target.[home-stats-team-pt]) IS NOT NULL OR NULLIF(Target.[home-stats-team-pt], Source.[home-stats-team-pt]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-ptyds], Target.[home-stats-team-ptyds]) IS NOT NULL OR NULLIF(Target.[home-stats-team-ptyds], Source.[home-stats-team-ptyds]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-trnovr], Target.[home-stats-team-trnovr]) IS NOT NULL OR NULLIF(Target.[home-stats-team-trnovr], Source.[home-stats-team-trnovr]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-pyds], Target.[home-stats-team-pyds]) IS NOT NULL OR NULLIF(Target.[home-stats-team-pyds], Source.[home-stats-team-pyds]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-ryds], Target.[home-stats-team-ryds]) IS NOT NULL OR NULLIF(Target.[home-stats-team-ryds], Source.[home-stats-team-ryds]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-totyds], Target.[home-stats-team-totyds]) IS NOT NULL OR NULLIF(Target.[home-stats-team-totyds], Source.[home-stats-team-totyds]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-ptavg], Target.[home-stats-team-ptavg]) IS NOT NULL OR NULLIF(Target.[home-stats-team-ptavg], Source.[home-stats-team-ptavg]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-pen], Target.[home-stats-team-pen]) IS NOT NULL OR NULLIF(Target.[home-stats-team-pen], Source.[home-stats-team-pen]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-penyds], Target.[home-stats-team-penyds]) IS NOT NULL OR NULLIF(Target.[home-stats-team-penyds], Source.[home-stats-team-penyds]) IS NOT NULL OR 
	NULLIF(Source.[home-stats-team-top], Target.[home-stats-team-top]) IS NOT NULL OR NULLIF(Target.[home-stats-team-top], Source.[home-stats-team-top]) IS NOT NULL OR 
  Target.deletets IS NOT NULL) THEN
 UPDATE SET
  [home-abbr] = Source.[home-abbr], 
  [home-players] = Source.[home-players], 
  [away-to] = Source.[away-to], 
  [away-stats-team-totfd] = Source.[away-stats-team-totfd], 
  [away-stats-team-pt] = Source.[away-stats-team-pt], 
  [away-stats-team-ptyds] = Source.[away-stats-team-ptyds], 
  [away-stats-team-trnovr] = Source.[away-stats-team-trnovr], 
  [away-stats-team-pyds] = Source.[away-stats-team-pyds], 
  [away-stats-team-ryds] = Source.[away-stats-team-ryds], 
  [away-stats-team-totyds] = Source.[away-stats-team-totyds], 
  [away-stats-team-ptavg] = Source.[away-stats-team-ptavg], 
  [away-stats-team-pen] = Source.[away-stats-team-pen], 
  [away-stats-team-penyds] = Source.[away-stats-team-penyds], 
  [away-stats-team-top] = Source.[away-stats-team-top], 
  [away-abbr] = Source.[away-abbr], 
  [away-players] = Source.[away-players], 
  [home-to] = Source.[home-to], 
  [home-stats-team-totfd] = Source.[home-stats-team-totfd], 
  [home-stats-team-pt] = Source.[home-stats-team-pt], 
  [home-stats-team-ptyds] = Source.[home-stats-team-ptyds], 
  [home-stats-team-trnovr] = Source.[home-stats-team-trnovr], 
  [home-stats-team-pyds] = Source.[home-stats-team-pyds], 
  [home-stats-team-ryds] = Source.[home-stats-team-ryds], 
  [home-stats-team-totyds] = Source.[home-stats-team-totyds], 
  [home-stats-team-ptavg] = Source.[home-stats-team-ptavg], 
  [home-stats-team-pen] = Source.[home-stats-team-pen], 
  [home-stats-team-penyds] = Source.[home-stats-team-penyds], 
  [home-stats-team-top] = Source.[home-stats-team-top],
   [modifyts] = @datetime,
    deletets = NULL 
WHEN NOT MATCHED BY TARGET THEN
 INSERT([eid],[home-abbr],[home-players],[away-to],[away-stats-team-totfd],[away-stats-team-pt],[away-stats-team-ptyds],[away-stats-team-trnovr],[away-stats-team-pyds],[away-stats-team-ryds],[away-stats-team-totyds],[away-stats-team-ptavg],[away-stats-team-pen],[away-stats-team-penyds],[away-stats-team-top],[away-abbr],[away-players],[home-to],[home-stats-team-totfd],[home-stats-team-pt],[home-stats-team-ptyds],[home-stats-team-trnovr],[home-stats-team-pyds],[home-stats-team-ryds],[home-stats-team-totyds],[home-stats-team-ptavg],[home-stats-team-pen],[home-stats-team-penyds],[home-stats-team-top],[createts],[modifyts],[deletets])
 VALUES(Source.[eid],Source.[home-abbr],Source.[home-players],Source.[away-to],Source.[away-stats-team-totfd],Source.[away-stats-team-pt],Source.[away-stats-team-ptyds],Source.[away-stats-team-trnovr],Source.[away-stats-team-pyds],Source.[away-stats-team-ryds],Source.[away-stats-team-totyds],Source.[away-stats-team-ptavg],Source.[away-stats-team-pen],Source.[away-stats-team-penyds],Source.[away-stats-team-top],Source.[away-abbr],Source.[away-players],Source.[home-to],Source.[home-stats-team-totfd],Source.[home-stats-team-pt],Source.[home-stats-team-ptyds],Source.[home-stats-team-trnovr],Source.[home-stats-team-pyds],Source.[home-stats-team-ryds],Source.[home-stats-team-totyds],Source.[home-stats-team-ptavg],Source.[home-stats-team-pen],Source.[home-stats-team-penyds],Source.[home-stats-team-top],@datetime,@datetime,NULL)
WHEN NOT MATCHED BY SOURCE AND Target.deletets IS NULL AND Target.eid IN  (SELECT DISTINCT eid FROM [LandNFL].[game])  THEN  
  UPDATE SET	deletets = @datetime
OUTPUT $action INTO @SummaryOfChanges
;
DECLARE @mergeError int
 , @mergeCount int
SELECT @mergeError = @@ERROR, @mergeCount = @@ROWCOUNT
IF @mergeError != 0
 BEGIN
 PRINT 'ERROR OCCURRED IN MERGE FOR [MasterNFL].[game]. Rows affected: ' + CAST(@mergeCount AS VARCHAR(100)); -- SQL should always return zero rows affected
 END
ELSE
 BEGIN
 PRINT '[MasterNFL].[game] rows affected by MERGE: ' + CAST(@mergeCount AS VARCHAR(100));
 END
;


DECLARE @rowcount int = @mergeCount, 
		@insert INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'INSERT'), 
		@update INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'update'), 
		@delete INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'DELETE')  
 EXEC dbo.LogProcedure @ProcID = @@PROCID, @RowCount = @rowcount,@insert = @insert,@update = @update, @delete = @delete, @starttime = @datetime, @isStart = false
;

SET NOCOUNT OFF
;



GO
/****** Object:  StoredProcedure [MasterNFL].[CDCplay]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [MasterNFL].[CDCplay]
as

--MERGE generated by 'sp_generate_merge' stored procedure, Version 0.93
--Originally by Vyas (http://vyaskn.tripod.com): sp_generate_inserts (build 22)
--Adapted for SQL Server 2008/2012 by Daniel Nolan (http://danere.com)

SET NOCOUNT ON

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));
DECLARE @datetime DATETIMEOFFSET = GETDATE(); 
EXEC dbo.LogProcedure @ProcID =  @@PROCID, @TableName = '[MasterNFL].[play]', @starttime = @datetime, @isStart = true
;
MERGE INTO [MasterNFL].[play] AS Target
USING  ( 
Select [eid],[drivenumber],[playnumber],[posteam],[desc],[ydstogo],[note],[qtr],[yrdln],[sp],[down],[time],[ydsnet]
 From[LandNFL].[play]
) AS Source ([eid],[drivenumber],[playnumber],[posteam],[desc],[ydstogo],[note],[qtr],[yrdln],[sp],[down],[time],[ydsnet])
ON (Target.[drivenumber] = Source.[drivenumber] AND Target.[eid] = Source.[eid] AND Target.[playnumber] = Source.[playnumber])
WHEN MATCHED AND (
	NULLIF(Source.[posteam], Target.[posteam]) IS NOT NULL OR NULLIF(Target.[posteam], Source.[posteam]) IS NOT NULL OR 
	NULLIF(Source.[desc], Target.[desc]) IS NOT NULL OR NULLIF(Target.[desc], Source.[desc]) IS NOT NULL OR 
	NULLIF(Source.[ydstogo], Target.[ydstogo]) IS NOT NULL OR NULLIF(Target.[ydstogo], Source.[ydstogo]) IS NOT NULL OR 
	NULLIF(Source.[note], Target.[note]) IS NOT NULL OR NULLIF(Target.[note], Source.[note]) IS NOT NULL OR 
	NULLIF(Source.[qtr], Target.[qtr]) IS NOT NULL OR NULLIF(Target.[qtr], Source.[qtr]) IS NOT NULL OR 
	NULLIF(Source.[yrdln], Target.[yrdln]) IS NOT NULL OR NULLIF(Target.[yrdln], Source.[yrdln]) IS NOT NULL OR 
	NULLIF(Source.[sp], Target.[sp]) IS NOT NULL OR NULLIF(Target.[sp], Source.[sp]) IS NOT NULL OR 
	NULLIF(Source.[down], Target.[down]) IS NOT NULL OR NULLIF(Target.[down], Source.[down]) IS NOT NULL OR 
	NULLIF(Source.[time], Target.[time]) IS NOT NULL OR NULLIF(Target.[time], Source.[time]) IS NOT NULL OR 
	NULLIF(Source.[ydsnet], Target.[ydsnet]) IS NOT NULL OR NULLIF(Target.[ydsnet], Source.[ydsnet]) IS NOT NULL OR 
  Target.deletets IS NOT NULL) THEN
 UPDATE SET
  [posteam] = Source.[posteam], 
  [desc] = Source.[desc], 
  [ydstogo] = Source.[ydstogo], 
  [note] = Source.[note], 
  [qtr] = Source.[qtr], 
  [yrdln] = Source.[yrdln], 
  [sp] = Source.[sp], 
  [down] = Source.[down], 
  [time] = Source.[time], 
  [ydsnet] = Source.[ydsnet],
   [modifyts] = @datetime,
    deletets = NULL 
WHEN NOT MATCHED BY TARGET THEN
 INSERT([eid],[drivenumber],[playnumber],[posteam],[desc],[ydstogo],[note],[qtr],[yrdln],[sp],[down],[time],[ydsnet],[createts],[modifyts],[deletets])
 VALUES(Source.[eid],Source.[drivenumber],Source.[playnumber],Source.[posteam],Source.[desc],Source.[ydstogo],Source.[note],Source.[qtr],Source.[yrdln],Source.[sp],Source.[down],Source.[time],Source.[ydsnet],@datetime,@datetime,NULL)
WHEN NOT MATCHED BY SOURCE AND Target.deletets IS NULL AND Target.eid IN  (SELECT DISTINCT eid FROM [LandNFL].[play])  THEN  
  UPDATE SET	deletets = @datetime
OUTPUT $action INTO @SummaryOfChanges
;
DECLARE @mergeError int
 , @mergeCount int
SELECT @mergeError = @@ERROR, @mergeCount = @@ROWCOUNT
IF @mergeError != 0
 BEGIN
 PRINT 'ERROR OCCURRED IN MERGE FOR [MasterNFL].[play]. Rows affected: ' + CAST(@mergeCount AS VARCHAR(100)); -- SQL should always return zero rows affected
 END
ELSE
 BEGIN
 PRINT '[MasterNFL].[play] rows affected by MERGE: ' + CAST(@mergeCount AS VARCHAR(100));
 END
;


DECLARE @rowcount int = @mergeCount, 
		@insert INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'INSERT'), 
		@update INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'update'), 
		@delete INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'DELETE')  
 EXEC dbo.LogProcedure @ProcID = @@PROCID, @RowCount = @rowcount,@insert = @insert,@update = @update, @delete = @delete, @starttime = @datetime, @isStart = false
;

SET NOCOUNT OFF
;




GO
/****** Object:  StoredProcedure [MasterNFL].[CDCplayplayer]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [MasterNFL].[CDCplayplayer]
AS

--MERGE generated by 'sp_generate_merge' stored procedure, Version 0.93
--Originally by Vyas (http://vyaskn.tripod.com): sp_generate_inserts (build 22)
--Adapted for SQL Server 2008/2012 by Daniel Nolan (http://danere.com)

SET NOCOUNT ON

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));
DECLARE @datetime DATETIMEOFFSET = GETDATE(); 
EXEC dbo.LogProcedure @ProcID =  @@PROCID, @TableName = '[MasterNFL].[playplayer]', @starttime = @datetime, @isStart = true
;
MERGE INTO [MasterNFL].[playplayer] AS Target
USING  ( 
Select [eid],[drivenumber],[playnumber],[playerid],[statId],[sequence],[playerName],[clubcode],[yards]
 From[LandNFL].[playplayer]
) AS Source ([eid],[drivenumber],[playnumber],[playerid],[statId],[sequence],[playerName],[clubcode],[yards])
ON (Target.[drivenumber] = Source.[drivenumber] AND Target.[eid] = Source.[eid] AND Target.[playerid] = Source.[playerid] AND Target.[playnumber] = Source.[playnumber])
WHEN MATCHED AND (
	NULLIF(Source.[statId], Target.[statId]) IS NOT NULL OR NULLIF(Target.[statId], Source.[statId]) IS NOT NULL OR 
	NULLIF(Source.[sequence], Target.[sequence]) IS NOT NULL OR NULLIF(Target.[sequence], Source.[sequence]) IS NOT NULL OR 
	NULLIF(Source.[playerName], Target.[playerName]) IS NOT NULL OR NULLIF(Target.[playerName], Source.[playerName]) IS NOT NULL OR 
	NULLIF(Source.[clubcode], Target.[clubcode]) IS NOT NULL OR NULLIF(Target.[clubcode], Source.[clubcode]) IS NOT NULL OR 
	NULLIF(Source.[yards], Target.[yards]) IS NOT NULL OR NULLIF(Target.[yards], Source.[yards]) IS NOT NULL OR 
  Target.deletets IS NOT NULL) THEN
 UPDATE SET
  [statId] = Source.[statId], 
  [sequence] = Source.[sequence], 
  [playerName] = Source.[playerName], 
  [clubcode] = Source.[clubcode], 
  [yards] = Source.[yards],
   [modifyts] = @datetime,
    deletets = NULL 
WHEN NOT MATCHED BY TARGET THEN
 INSERT([eid],[drivenumber],[playnumber],[playerid],[statId],[sequence],[playerName],[clubcode],[yards],[createts],[modifyts],[deletets])
 VALUES(Source.[eid],Source.[drivenumber],Source.[playnumber],Source.[playerid],Source.[statId],Source.[sequence],Source.[playerName],Source.[clubcode],Source.[yards],@datetime,@datetime,NULL)
WHEN NOT MATCHED BY SOURCE AND Target.deletets IS NULL AND Target.eid IN  (SELECT DISTINCT eid FROM [LandNFL].[playplayer])  THEN  
  UPDATE SET	deletets = @datetime
OUTPUT $action INTO @SummaryOfChanges
;
DECLARE @mergeError int
 , @mergeCount int
SELECT @mergeError = @@ERROR, @mergeCount = @@ROWCOUNT
IF @mergeError != 0
 BEGIN
 PRINT 'ERROR OCCURRED IN MERGE FOR [MasterNFL].[playplayer]. Rows affected: ' + CAST(@mergeCount AS VARCHAR(100)); -- SQL should always return zero rows affected
 END
ELSE
 BEGIN
 PRINT '[MasterNFL].[playplayer] rows affected by MERGE: ' + CAST(@mergeCount AS VARCHAR(100));
 END
;


DECLARE @rowcount int = @mergeCount, 
		@insert INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'INSERT'), 
		@update INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'update'), 
		@delete INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'DELETE')  
 EXEC dbo.LogProcedure @ProcID = @@PROCID, @RowCount = @rowcount,@insert = @insert,@update = @update, @delete = @delete, @starttime = @datetime, @isStart = false
;

SET NOCOUNT OFF
;





GO
/****** Object:  StoredProcedure [MasterNFL].[CDCSchedule]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [MasterNFL].[CDCSchedule]
AS 

--MERGE generated by 'sp_generate_merge' stored procedure, Version 0.93
--Originally by Vyas (http://vyaskn.tripod.com): sp_generate_inserts (build 22)
--Adapted for SQL Server 2008/2012 by Daniel Nolan (http://danere.com)

SET NOCOUNT ON

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));
DECLARE @datetime DATETIMEOFFSET = GETDATE(); 
EXEC dbo.LogProcedure @ProcID =  @@PROCID, @TableName = '[MasterNFL].[schedule]', @starttime = @datetime, @isStart = true
;
MERGE INTO [MasterNFL].[schedule] AS Target
USING  ( 
Select [eid],[gsis],[SeasonYear],[SeasonType],[SeasonTypeDetail],[wkNumber],[DayName],[GameTime],[GameTimeUTC],[Qtr],[HomeTeam],[HomeTeamName],[AwayTeam],[AwayTeamName]
 From[LandNFL].[schedule_vw]
) AS Source ([eid],[gsis],[SeasonYear],[SeasonType],[SeasonTypeDetail],[wkNumber],[DayName],[GameTime],[GameTimeUTC],[Qtr],[HomeTeam],[HomeTeamName],[AwayTeam],[AwayTeamName])
ON (Target.[eid] = Source.[eid])
WHEN MATCHED AND (
	NULLIF(Source.[gsis], Target.[gsis]) IS NOT NULL OR NULLIF(Target.[gsis], Source.[gsis]) IS NOT NULL OR 
	NULLIF(Source.[SeasonYear], Target.[SeasonYear]) IS NOT NULL OR NULLIF(Target.[SeasonYear], Source.[SeasonYear]) IS NOT NULL OR 
	NULLIF(Source.[SeasonType], Target.[SeasonType]) IS NOT NULL OR NULLIF(Target.[SeasonType], Source.[SeasonType]) IS NOT NULL OR 
	NULLIF(Source.[SeasonTypeDetail], Target.[SeasonTypeDetail]) IS NOT NULL OR NULLIF(Target.[SeasonTypeDetail], Source.[SeasonTypeDetail]) IS NOT NULL OR 
	NULLIF(Source.[wkNumber], Target.[wkNumber]) IS NOT NULL OR NULLIF(Target.[wkNumber], Source.[wkNumber]) IS NOT NULL OR 
	NULLIF(Source.[DayName], Target.[DayName]) IS NOT NULL OR NULLIF(Target.[DayName], Source.[DayName]) IS NOT NULL OR 
	NULLIF(Source.[GameTime], Target.[GameTime]) IS NOT NULL OR NULLIF(Target.[GameTime], Source.[GameTime]) IS NOT NULL OR 
	NULLIF(Source.[GameTimeUTC], Target.[GameTimeUTC]) IS NOT NULL OR NULLIF(Target.[GameTimeUTC], Source.[GameTimeUTC]) IS NOT NULL OR 
	NULLIF(Source.[Qtr], Target.[Qtr]) IS NOT NULL OR NULLIF(Target.[Qtr], Source.[Qtr]) IS NOT NULL OR 
	NULLIF(Source.[HomeTeam], Target.[HomeTeam]) IS NOT NULL OR NULLIF(Target.[HomeTeam], Source.[HomeTeam]) IS NOT NULL OR 
	NULLIF(Source.[HomeTeamName], Target.[HomeTeamName]) IS NOT NULL OR NULLIF(Target.[HomeTeamName], Source.[HomeTeamName]) IS NOT NULL OR 
	NULLIF(Source.[AwayTeam], Target.[AwayTeam]) IS NOT NULL OR NULLIF(Target.[AwayTeam], Source.[AwayTeam]) IS NOT NULL OR 
	NULLIF(Source.[AwayTeamName], Target.[AwayTeamName]) IS NOT NULL OR NULLIF(Target.[AwayTeamName], Source.[AwayTeamName]) IS NOT NULL OR 
  Target.deletets IS NOT NULL) THEN
 UPDATE SET
  [gsis] = Source.[gsis], 
  [SeasonYear] = Source.[SeasonYear], 
  [SeasonType] = Source.[SeasonType], 
  [SeasonTypeDetail] = Source.[SeasonTypeDetail], 
  [wkNumber] = Source.[wkNumber], 
  [DayName] = Source.[DayName], 
  [GameTime] = Source.[GameTime], 
  [GameTimeUTC] = Source.[GameTimeUTC], 
  [Qtr] = Source.[Qtr], 
  [HomeTeam] = Source.[HomeTeam], 
  [HomeTeamName] = Source.[HomeTeamName], 
  [AwayTeam] = Source.[AwayTeam], 
  [AwayTeamName] = Source.[AwayTeamName],
   [modifyts] = @datetime,
    deletets = NULL 
WHEN NOT MATCHED BY TARGET THEN
 INSERT([eid],[gsis],[SeasonYear],[SeasonType],[SeasonTypeDetail],[wkNumber],[DayName],[GameTime],[GameTimeUTC],[Qtr],[HomeTeam],[HomeTeamName],[AwayTeam],[AwayTeamName],[createts],[modifyts],[deletets])
 VALUES(Source.[eid],Source.[gsis],Source.[SeasonYear],Source.[SeasonType],Source.[SeasonTypeDetail],Source.[wkNumber],Source.[DayName],Source.[GameTime],Source.[GameTimeUTC],Source.[Qtr],Source.[HomeTeam],Source.[HomeTeamName],Source.[AwayTeam],Source.[AwayTeamName],@datetime,@datetime,NULL)
WHEN NOT MATCHED BY SOURCE AND Target.deletets IS NULL AND Target.eid IN  (SELECT DISTINCT eid FROM [LandNFL].[schedule])  THEN  
  UPDATE SET	deletets = @datetime
OUTPUT $action INTO @SummaryOfChanges
;
DECLARE @mergeError int
 , @mergeCount int
SELECT @mergeError = @@ERROR, @mergeCount = @@ROWCOUNT
IF @mergeError != 0
 BEGIN
 PRINT 'ERROR OCCURRED IN MERGE FOR [MasterNFL].[schedule]. Rows affected: ' + CAST(@mergeCount AS VARCHAR(100)); -- SQL should always return zero rows affected
 END
ELSE
 BEGIN
 PRINT '[MasterNFL].[schedule] rows affected by MERGE: ' + CAST(@mergeCount AS VARCHAR(100));
 END
;


DECLARE @rowcount int = @mergeCount, 
		@insert INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'INSERT'), 
		@update INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'update'), 
		@delete INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'DELETE')  
 EXEC dbo.LogProcedure @ProcID = @@PROCID, @RowCount = @rowcount,@insert = @insert,@update = @update, @delete = @delete, @starttime = @datetime, @isStart = false
;

SET NOCOUNT OFF
;


GO
/****** Object:  StoredProcedure [NFLDB].[BuildSchedule]    Script Date: 1/25/2018 4:45:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [NFLDB].[BuildSchedule]
AS

--MERGE generated by 'sp_generate_merge' stored procedure, Version 0.93
--Originally by Vyas (http://vyaskn.tripod.com): sp_generate_inserts (build 22)
--Adapted for SQL Server 2008/2012 by Daniel Nolan (http://danere.com)

SET NOCOUNT ON

DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));
DECLARE @datetime DATETIMEOFFSET = GETDATE(); 
EXEC dbo.LogProcedure @ProcID =  @@PROCID, @TableName = '[nfldb].[schedule]', @starttime = @datetime, @isStart = true
;
MERGE INTO [nfldb].[schedule] AS Target
USING  ( 
Select [GameID],[SeasonYear],[SeasonType],[SeasonTypeDetail],[WkNumber],[DayName],[GameTime],[GameTimeUTC],[Qtr],[HomeTeam],[HomeTeamName],[AwayTeam],[AwayTeamName]
 From[nfldb].[schedule_vw]
) AS Source ([GameID],[SeasonYear],[SeasonType],[SeasonTypeDetail],[WkNumber],[DayName],[GameTime],[GameTimeUTC],[Qtr],[HomeTeam],[HomeTeamName],[AwayTeam],[AwayTeamName])
ON (Target.[GameID] = Source.[GameID])
WHEN MATCHED AND (
	NULLIF(Source.[GameID], Target.[GameID]) IS NOT NULL OR NULLIF(Target.[GameID], Source.[GameID]) IS NOT NULL OR 
	NULLIF(Source.[SeasonYear], Target.[SeasonYear]) IS NOT NULL OR NULLIF(Target.[SeasonYear], Source.[SeasonYear]) IS NOT NULL OR 
	NULLIF(Source.[SeasonType], Target.[SeasonType]) IS NOT NULL OR NULLIF(Target.[SeasonType], Source.[SeasonType]) IS NOT NULL OR 
	NULLIF(Source.[SeasonTypeDetail], Target.[SeasonTypeDetail]) IS NOT NULL OR NULLIF(Target.[SeasonTypeDetail], Source.[SeasonTypeDetail]) IS NOT NULL OR 
	NULLIF(Source.[WkNumber], Target.[WkNumber]) IS NOT NULL OR NULLIF(Target.[WkNumber], Source.[WkNumber]) IS NOT NULL OR 
	NULLIF(Source.[DayName], Target.[DayName]) IS NOT NULL OR NULLIF(Target.[DayName], Source.[DayName]) IS NOT NULL OR 
	NULLIF(Source.[GameTime], Target.[GameTime]) IS NOT NULL OR NULLIF(Target.[GameTime], Source.[GameTime]) IS NOT NULL OR 
	NULLIF(Source.[GameTimeUTC], Target.[GameTimeUTC]) IS NOT NULL OR NULLIF(Target.[GameTimeUTC], Source.[GameTimeUTC]) IS NOT NULL OR 
	NULLIF(Source.[Qtr], Target.[Qtr]) IS NOT NULL OR NULLIF(Target.[Qtr], Source.[Qtr]) IS NOT NULL OR 
	NULLIF(Source.[HomeTeam], Target.[HomeTeam]) IS NOT NULL OR NULLIF(Target.[HomeTeam], Source.[HomeTeam]) IS NOT NULL OR 
	NULLIF(Source.[HomeTeamName], Target.[HomeTeamName]) IS NOT NULL OR NULLIF(Target.[HomeTeamName], Source.[HomeTeamName]) IS NOT NULL OR 
	NULLIF(Source.[AwayTeam], Target.[AwayTeam]) IS NOT NULL OR NULLIF(Target.[AwayTeam], Source.[AwayTeam]) IS NOT NULL OR 
	NULLIF(Source.[AwayTeamName], Target.[AwayTeamName]) IS NOT NULL OR NULLIF(Target.[AwayTeamName], Source.[AwayTeamName]) IS NOT NULL) THEN 
 UPDATE SET
  [GameID] = Source.[GameID], 
  [SeasonYear] = Source.[SeasonYear], 
  [SeasonType] = Source.[SeasonType], 
  [SeasonTypeDetail] = Source.[SeasonTypeDetail], 
  [WkNumber] = Source.[WkNumber], 
  [DayName] = Source.[DayName], 
  [GameTime] = Source.[GameTime], 
  [GameTimeUTC] = Source.[GameTimeUTC], 
  [Qtr] = Source.[Qtr], 
  [HomeTeam] = Source.[HomeTeam], 
  [HomeTeamName] = Source.[HomeTeamName], 
  [AwayTeam] = Source.[AwayTeam], 
  [AwayTeamName] = Source.[AwayTeamName]
WHEN NOT MATCHED BY TARGET THEN
 INSERT([GameID],[SeasonYear],[SeasonType],[SeasonTypeDetail],[WkNumber],[DayName],[GameTime],[GameTimeUTC],[Qtr],[HomeTeam],[HomeTeamName],[AwayTeam],[AwayTeamName] )
 VALUES(Source.[GameID],Source.[SeasonYear],Source.[SeasonType],Source.[SeasonTypeDetail],Source.[WkNumber],Source.[DayName],Source.[GameTime],Source.[GameTimeUTC],Source.[Qtr],Source.[HomeTeam],Source.[HomeTeamName],Source.[AwayTeam],Source.[AwayTeamName])
WHEN NOT MATCHED BY SOURCE THEN 
 DELETE
 OUTPUT $action INTO @SummaryOfChanges 
;
DECLARE @mergeError int
 , @mergeCount int
SELECT @mergeError = @@ERROR, @mergeCount = @@ROWCOUNT
IF @mergeError != 0
 BEGIN
 PRINT 'ERROR OCCURRED IN MERGE FOR [nfldb].[schedule]. Rows affected: ' + CAST(@mergeCount AS VARCHAR(100)); -- SQL should always return zero rows affected
 END
ELSE
 BEGIN
 PRINT '[nfldb].[schedule] rows affected by MERGE: ' + CAST(@mergeCount AS VARCHAR(100));
 END
;


DECLARE @rowcount int = @mergeCount, 
		@insert INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'INSERT'), 
		@update INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'update'), 
		@delete INT = (SELECT COUNT(1) FROM @SummaryOfChanges WHERE Change = 'DELETE')  
 EXEC dbo.LogProcedure @ProcID = @@PROCID, @RowCount = @rowcount,@insert = @insert,@update = @update, @delete = @delete, @starttime = @datetime, @isStart = false
;

GO

INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (0,'PRE','Preseason')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (1,'PRE','Preseason')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (2,'PRE','Preseason')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (3,'PRE','Preseason')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (4,'PRE','Preseason')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (1,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (2,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (3,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (4,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (5,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (6,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (7,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (8,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (9,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (10,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (11,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (12,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (13,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (14,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (15,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (16,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (17,'REG','Regular')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (18,'POST','Wild Card')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (19,'POST','Divisional')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (20,'POST','Conference ')
INSERT INTO NFLDB.ScheduleDefinition(week,SeasonType,DESCRIPTION) VALUES (22,'POST','Super Bowl')

CREATE EXTERNAL DATA SOURCE nflgenstorage
WITH ( TYPE = BLOB_STORAGE, LOCATION = 'https://nflgenstoragers.blob.core.windows.net');

SET NOCOUNT OFF
;

