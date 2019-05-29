-- clerks
SELECT TOP 10 [type], SUM(pages_kb) / 1024 AS SizeMb
FROM sys.dm_os_memory_clerks
GROUP BY [type]
ORDER BY SUM(pages_kb) / 1024 DESC

-- current memory
SELECT (physical_memory_in_use_kb/1024)/1024 AS [PhysicalMemInUseGB]
FROM sys.dm_os_process_memory;
GO

-- Get max memory current available
SELECT c.value, c.value_in_use
FROM sys.configurations c WHERE c.[name] = 'max server memory (MB)'

-- reconfigure for 4GB
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'max server memory', 4096;
GO
RECONFIGURE;
GO

--https://docs.microsoft.com/pt-br/sql/database-engine/configure-windows/server-memory-server-configuration-options?view=sql-server-2017
