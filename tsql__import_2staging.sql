----
---- step01 import
--SELECT *
--into   staging.[ES06-25.Last_min__20250401_20250426]
--FROM   CLR.dbo.tfn_readFile_UTF8('C:\__temp\ES06-25.Last_min__20250401_20250426.txt')
----

DECLARE @inputstring nvarchar(100)
      , @separator   nvarchar(1)
      , @ordinalpos  int

SET @inputstring = '20250331 220100;5644.25;5645.5;5643;5643.25;526'
SET @separator   = ';'
SET @ordinalpos  = 3

SELECT *
FROM   dbo.tfn_StringSplit_custom( @inputstring, @separator, 1 )

----------------

SELECT 
       T1.lineNumber
     , T1.lineText
     , v1.value      as 'col1'  -- date time
     , v2.value      as 'col2'  -- open
     , v3.value      as 'col3'  -- high
     , v4.value      as 'col4'  -- low 
     , v5.value      as 'col5'  -- close
     , v6.value      as 'col6'  -- volume
into   staging.ES_step01
FROM   [staging].[ES06-25.Last_min__20250401_20250426] T1
cross  apply
       dbo.tfn_StringSplit_custom( lineText, ';', 1 ) V1
cross  apply
       dbo.tfn_StringSplit_custom( lineText, ';', 2 ) V2
cross  apply
       dbo.tfn_StringSplit_custom( lineText, ';', 3 ) V3
cross  apply
       dbo.tfn_StringSplit_custom( lineText, ';', 4 ) V4
cross  apply
       dbo.tfn_StringSplit_custom( lineText, ';', 5 ) V5
cross  apply
       dbo.tfn_StringSplit_custom( lineText, ';', 6 ) V6
----


----SELECT 
----       lineNumber
----     , lineText
----     , Convert( date, Left(col1, 8), 112) as 'date'   -- 112 = ISO yyyymmdd 
----     , Convert( time, SubString( col1, 10, 2 ) + ':' + 
----                      SubString( col1, 12, 2 ) + ':' + 
----                      SubString( col1, 14, 2 )        -- 108 = hh:mi:ss
----              , 108 )                  as 'time' 
----     ----
----     , Try_Cast(col2 as decimal(10,2)) as 'open'
----     , Try_Cast(col3 as decimal(10,2)) as 'high'
----     , Try_Cast(col4 as decimal(10,2)) as 'low' 
----     , Try_Cast(col5 as decimal(10,2)) as 'close'
----     , Try_Cast(col6 as int          ) as 'volume'
----FROM   staging.ES_step01

SELECT 
       lineNumber
     , lineText
     , Convert( date, Left(col1, 8), 112) as 'date'   -- 112 = ISO yyyymmdd 
     , Convert( datetime, Left(col1, 8), 112) --as 'date'   -- 112 = ISO yyyymmdd 
     + Convert( datetime, SubString( col1, 10, 2 ) + ':' + 
                          SubString( col1, 12, 2 ) + ':' + 
                          SubString( col1, 14, 2 )        -- 108 = hh:mi:ss
              , 108 )                  as 'datetime' 
     ----
     , Try_Cast(col2 as decimal(10,2)) as 'open'
     , Try_Cast(col3 as decimal(10,2)) as 'high'
     , Try_Cast(col4 as decimal(10,2)) as 'low' 
     , Try_Cast(col5 as decimal(10,2)) as 'close'
     , Try_Cast(col6 as int          ) as 'volume'
into   staging.ES_step02
FROM   staging.ES_step01

----  end  ----

