/* 1) TABLE DDL */
/* 2) SAMPLE ROWS */
/* 3) TEMPORARY TABLE DDL and INSERT */
/* 4) TABLE-VALUED FUNCTION */
/* 5A) SAMPLE QUERY 1: SUMMARY COUNTS BY HIERARCHY LEVEL */
/* 5B) SAMPLE QUERY 2: SUB-SELECT BASED ON HIERARCHY LEVEL */

/* 1) TABLE DDL */
drop table if exists test_mycatalog;
go
create table test_mycatalog(
  parent_id			varchar(500),
  document_name		varchar(500),
  data_id			varchar(500));
go

/* 2) SAMPLE ROWS */
insert test_mycatalog(parent_id, document_name, data_id) values
(NULL,'CORP','1'),
('1','IT','11'),
('1','FIN','22'),
('1','HR','33'),
('1','Sales','44'),
('1','Legal','55'),
('11','IT Policy','11-1'),
('11','IT Procedure','11-2'),
('11','IT Deployment','11-3'),
('22','Financial report','22-1'),
('22','Financial stmnts','22-2'),
('22','Financial Release','22-3'),
('22','Financial policy','22-4'),
('33','HR Process','33-2'),
('33','HR Process','33-3'),
('33','HR Process','33-4'),
('11-1','IT Network Policy','11-1A'),
('11-2','IT Database Policy','11-2A'),
('11-3','IT Deployment 11-3A','11-3A'),
('11-1A','IT N/W Policy configuration','11-1A_1'),
('11-2A','IT DB Maint Policy','11-2A_1');
go

/* 3) TEMPORARY TABLE DDL and INSERT */
drop table if exists #tm_hierarchies;
go
create table #tm_hierarchies(
	data_id			varchar(500) unique not null,
	parent_id		varchar(500),
	document_name	varchar(500),
	h_level			int not null);
go

with 
recur_cte(data_id, parent_id, document_name, h_level) as (
	select
  	  data_id,
	  parent_id,
	  document_name,
	  0
	from
	  test_mycatalog
	where
	  parent_id is null
	union all
	select
	  cat.data_id,
	  cat.parent_id,
	  cat.document_name,
	  rc.h_level+1
	from
	  test_mycatalog cat
	 join
	  recur_cte rc on cat.parent_id=rc.data_id)
insert #tm_hierarchies(data_id, parent_id, document_name, h_level)
select * from recur_cte;
go

/* 4) TABLE-VALUED FUNCTION */
drop function if exists dbo.downlines;
go
create function dbo.downlines(
  @data_id			varchar(500))
returns table as 
return
with inner_recur_cte(data_id, parent_id, h_level) as(
	select data_id, parent_id, cast(0 as int) from test_mycatalog where data_id=@data_id
	union all
	select
	  cat.data_id, cat.parent_id, rc.h_level+1 
	from
	  test_mycatalog cat
	 join
	  inner_recur_cte rc on cat.parent_id=rc.data_id)
select
  sum(iif(h_level=1,1,0)) lvl_1_count,
  sum(iif(h_level=2,1,0)) lvl_2_count,
  sum(iif(h_level=3,1,0)) lvl_3_count,
  sum(iif(h_level=4,1,0)) lvl_4_count,
  sum(iif(h_level=5,1,0)) lvl_5_count,
  count(*)-1 lvl_all_count,
  (select * from inner_recur_cte for json path, root('downlines')) json_downlines
from
  inner_recur_cte;
go

/* 5A) SAMPLE QUERY 1: SUMMARY COUNTS BY HIERARCHY LEVEL */
select
  *
from
  #tm_hierarchies tm
 cross apply
  dbo.downlines(tm.data_id);

/* 5B) SAMPLE QUERY 2: SUB-SELECT BASED ON HIERARCHY LEVEL */
with tm_downlines_cte as (
	select
	  *
	from
	  #tm_hierarchies th
	 cross apply
	  dbo.downlines(th.data_id))
select 
  dl.data_id, dl.parent_id, dl.h_level, tm.document_name
from
  tm_downlines_cte tdc
 cross apply
  openjson(tdc.json_downlines, N'strict $.downlines')  with (data_id varchar(500), parent_id varchar(500), h_level int) dl
 join
  test_mycatalog tm on dl.data_id=tm.data_id
where
  tdc.data_id='11'
  and dl.h_level='2';
