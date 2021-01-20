IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_AT]') )
    DROP PROCEDURE [dbo].[SP_AT]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_RAT]') )
    DROP PROCEDURE [dbo].[SP_RAT]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_AT2]') )
    DROP PROCEDURE [dbo].[SP_AT2]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_ATC]') )
    DROP PROCEDURE [dbo].[SP_ATC]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_RATC]') )
    DROP PROCEDURE [dbo].[SP_RATC]    
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_ATC2]') )
    DROP PROCEDURE [dbo].[SP_ATC2]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_PADC]') )
    DROP PROCEDURE [dbo].[SP_PADC]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_PADL]') )
    DROP PROCEDURE [dbo].[SP_PADL]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_PADR]') )
    DROP PROCEDURE [dbo].[SP_PADR]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_STRTRAN]') )
    DROP PROCEDURE [dbo].[SP_STRTRAN]    
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_CHRTRAN]') )
    DROP PROCEDURE [dbo].[SP_CHRTRAN]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_STRFILTER]') )
    DROP PROCEDURE [dbo].[SP_STRFILTER]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_OCCURS]') )
    DROP PROCEDURE [dbo].[SP_OCCURS]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_OCCURS2]') )
    DROP PROCEDURE [dbo].[SP_OCCURS2]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_PROPER]') )
    DROP PROCEDURE [dbo].[SP_PROPER]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_GETWORDCOUNT]') )
    DROP PROCEDURE [dbo].[SP_GETWORDCOUNT]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_GETWORDNUM]') )
    DROP PROCEDURE [dbo].[SP_GETWORDNUM]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_GETALLWORDS]') )
    DROP PROCEDURE [dbo].[SP_GETALLWORDS]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_GETALLWORDS2]') )
    DROP PROCEDURE [dbo].[SP_GETALLWORDS2]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_RCHARINDEX]') )
    DROP PROCEDURE [dbo].[SP_RCHARINDEX]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_CHARINDEX_BIN]') )
    DROP PROCEDURE [dbo].[SP_CHARINDEX_BIN]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_CHARINDEX_CI]') )
    DROP PROCEDURE [dbo].[SP_CHARINDEX_CI]    
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_ARABTOROMAN]') )
    DROP PROCEDURE [dbo].[SP_ARABTOROMAN]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_ROMANTOARAB]') )
    DROP PROCEDURE [dbo].[SP_ROMANTOARAB]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_ADDROMANNUMBERS]') )
    DROP PROCEDURE [dbo].[SP_ADDROMANNUMBERS]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_COMPARISON_EXACT]') )
    DROP PROCEDURE [dbo].[SP_COMPARISON_EXACT]
IF EXISTS (select 1 from   dbo.sysobjects where  id = object_id('[dbo].[SP_REPLACE]') )
    DROP PROCEDURE [dbo].[SP_REPLACE]
GO
