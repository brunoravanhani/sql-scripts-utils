--pages
dbcc ind (
	'Banco',
	'dbo.Tabela',
	1
)

dbcc traceon(3604)
dbcc page (
	'Banco',
	1,
	id da page,
	3
)

select * from sys.dm_db_database_page_allocations(DB_ID(), OBJECT_ID('tabela'), NULL, NULL, 'DETAILED')
