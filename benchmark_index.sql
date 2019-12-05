-- create table and indexes

USE [tempdb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[t1](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [c1] [varchar](200) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[t2](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [c1] [varchar](200) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[t3](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [c1] [varchar](200) NULL
) ON [PRIMARY]

GO

CREATE CLUSTERED INDEX CIX_t1 ON t1(id)

CREATE NONCLUSTERED INDEX IX_t2 ON t2(id)

CREATE CLUSTERED INDEX CIX_t3 ON t3(id)
CREATE NONCLUSTERED INDEX IX_t3 ON t3(id)


----- populate tables


DECLARE @i INT
DECLARE @j int
DECLARE @t DATETIME
SET NOCOUNT ON
SET @t = CURRENT_TIMESTAMP
SET @i = 0
WHILE @i < 10000000
BEGIN
--populate with strings with a length between 100 and 200 
INSERT INTO t1 (c1) VALUES (REPLICATE('x', 101+ CAST(RAND(@i) * 100 AS INT)))
SET @i = @i + 1
END

PRINT 'Time to populate t1: '+ CAST(DATEDIFF(ms, @t, CURRENT_TIMESTAMP) AS VARCHAR(10)) + ' ms'
SET @t = CURRENT_TIMESTAMP


SET @i = 0
WHILE @i < 10000000
BEGIN
--populate with strings with a length between 100 and 200 
INSERT INTO t2 (c1) VALUES (REPLICATE('x', 101+ CAST(RAND(@i) * 100 AS INT)))
SET @i = @i + 1
END

PRINT 'Time to populate t3: '+ CAST(DATEDIFF(ms, @t, CURRENT_TIMESTAMP) AS VARCHAR(10)) + ' ms'
SET @t = CURRENT_TIMESTAMP

SET @i = 0
WHILE @i < 10000000
BEGIN
--populate with strings with a length between 100 and 200 
INSERT INTO t3 (c1) VALUES (REPLICATE('x', 101+ CAST(RAND(@i) * 100 AS INT)))
SET @i = @i + 1
END

PRINT 'Time to populate t3: '+ CAST(DATEDIFF(ms, @t, CURRENT_TIMESTAMP) AS VARCHAR(10)) + ' ms'


------- select

SELECT  OBJECT_NAME(OBJECT_ID) table_name, index_id, index_type_desc, 
record_count, page_count, page_count / 128.0 size_in_mb, avg_record_size_in_bytes
FROM    sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('t1'), NULL, NULL, 'detailed')
WHERE   index_level = 0 
UNION ALL
SELECT  OBJECT_NAME(OBJECT_ID) table_name, index_id, index_type_desc, 
record_count, page_count, page_count / 128.0 size_in_mb, avg_record_size_in_bytes
FROM    sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('t2'), NULL, NULL, 'detailed')
WHERE   index_level = 0 
UNION ALL
SELECT  OBJECT_NAME(OBJECT_ID) table_name, index_id, index_type_desc, 
record_count, page_count, page_count / 128.0 size_in_mb, avg_record_size_in_bytes
FROM    sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('t3'), NULL, NULL, 'detailed')
WHERE   index_level = 0 

/*

T1's clustered index is around 1.6 GB in size. T2's non-clustered index is 170 MB (90% savings in IO). T3's non-clustered index is 97 MB, or about 95% less IO than T1.

So, based off of the IO required, the original query plan should have been more along the lines of 10%/90%, not 38%/62%. Also, since the non-clustered index is likely to fit entirely in memory, the difference may be greater still, as disk IO is very expensive.
*/