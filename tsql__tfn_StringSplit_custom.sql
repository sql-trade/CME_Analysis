CREATE FUNCTION dbo.tfn_StringSplit_custom
(
        @inputstring nvarchar(100) 
      , @separator   nvarchar(1)   
      , @ordinalpos  int           
)
RETURNS TABLE
AS
RETURN
(

WITH
SubQuery as
(
  SELECT ROW_NUMBER() over( Order by (select 1) ) as 'rowNr'
       , *
  FROM   string_split( @inputstring, @separator )
)
SELECT *
FROM   SubQuery
WHERE  rowNr = @ordinalpos
)
--  end FUNCTION