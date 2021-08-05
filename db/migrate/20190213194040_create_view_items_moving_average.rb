class CreateViewItemsMovingAverage < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists ItemsMovingAve
    SQL

    execute <<-SQL
      CREATE VIEW ItemsMovingAve AS
      SELECT
        ITEMNO, LOCATION
        --Average quantity sales
        ,TOWYEARSQTY
        ,FOURQUARTERQTY
        ,THIRDQUARTERQTY
        ,SECONDQUARTERQTY
        ,FIRSTQUARTERQTY
        --Average amunt sales
        ,TOWYEARSAMT
        ,FOURQUARTERAMT
        ,THIRDQUARTERAMT
        ,SECONDQUARTERAMT
        ,FIRSTQUARTERAMT
        -- Sales Counts
        ,TOWYEARSCOUNT
        ,FOURQUARTERCOUNT
        ,THIRDQUARTERCOUNT
        ,SECONDQUARTERCOUNT
        ,FIRSTQUARTERCOUNT
      FROM
        (
          SELECT
            ITEMNO
            ,LOCATION
            ,[Fiscal Year]
            ,[Fiscal Period]
            ,[Sales Quantity]
            ,[Sales Count]
            -- Sales Averages
            ,AVG([Sales Quantity]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 23 PRECEDING AND 0 FOLLOWING)  AS TOWYEARSQTY
            ,AVG([Sales Quantity]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 11 PRECEDING AND 0 FOLLOWING)  AS FOURQUARTERQTY
             ,AVG([Sales Quantity]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 8 PRECEDING AND 0 FOLLOWING)  AS THIRDQUARTERQTY
            ,AVG([Sales Quantity]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 5 PRECEDING AND 0 FOLLOWING)  AS SECONDQUARTERQTY
            ,AVG([Sales Quantity]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 2 PRECEDING AND 0 FOLLOWING)  AS FIRSTQUARTERQTY
            -- Sales Amount
            ,AVG([Sales Amount]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 23 PRECEDING AND 0 FOLLOWING)  AS TOWYEARSAMT
            ,AVG([Sales Amount]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 11 PRECEDING AND 0 FOLLOWING)  AS FOURQUARTERAMT
            ,AVG([Sales Amount]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 8 PRECEDING AND 0 FOLLOWING)  AS THIRDQUARTERAMT
            ,AVG([Sales Amount]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 5 PRECEDING AND 0 FOLLOWING)  AS SECONDQUARTERAMT
            ,AVG([Sales Amount]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 2 PRECEDING AND 0 FOLLOWING)  AS FIRSTQUARTERAMT
            -- Sales Count
            ,SUM([Sales Count]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 24 PRECEDING AND CURRENT ROW)  AS TOWYEARSCOUNT
            ,SUM([Sales Count]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)  AS FOURQUARTERCOUNT
            ,SUM([Sales Count]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 8 PRECEDING AND CURRENT ROW)  AS THIRDQUARTERCOUNT
            ,SUM([Sales Count]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 5 PRECEDING AND CURRENT ROW)  AS SECONDQUARTERCOUNT
            ,SUM([Sales Count]) OVER (PARTITION BY ITEMNO, LOCATION ORDER BY [Fiscal Year], [Fiscal Period] ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)  AS FIRSTQUARTERCOUNT
        FROM
        (
          SELECT DISTINCT
            il.ITEMNO
            ,il.LOCATION
            ,CAST(ff.FSCYEAR AS INT) AS "Fiscal Year"
            ,ff.Period AS "Fiscal Period"
            ,ISNULL((SELECT iss.SALESQTY FROM dbo.ICSTATI iss
              WHERE iss.ITEMNO = il.ITEMNO
              AND iss.LOCATION = il.LOCATION
              AND iss.[YEAR] = ff.FSCYEAR
              AND iss.PERIOD = ff.Period),0) AS "Sales Quantity"
            ,ISNULL((SELECT iss.SALESAMT FROM dbo.ICSTATI iss
              WHERE iss.ITEMNO = il.ITEMNO
              AND iss.LOCATION = il.LOCATION
              AND iss.[YEAR] = ff.FSCYEAR
              AND iss.PERIOD = ff.Period),0) AS "Sales Amount"
            ,ISNULL((SELECT iss.SALESCOUNT FROM dbo.ICSTATI iss
              WHERE iss.ITEMNO = il.ITEMNO
              AND iss.LOCATION = il.LOCATION
              AND iss.[YEAR] = ff.FSCYEAR
              AND iss.PERIOD = ff.Period),0) AS "Sales Count"
          FROM dbo.ICILOC il
          RIGHT JOIN
            (
              SELECT f.FSCYEAR, 1 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE1])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 2 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE2])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 3 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE3])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 4 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE4])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 5 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE5])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 6 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE6])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 7 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE7])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 8 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE8])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 9 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE9])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 10 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE10])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 11 AS "Period" from [dbo].[CSFSC] f WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE11])),0)) < GETDATE()
              UNION SELECT f.FSCYEAR, 12 AS "Period" from [dbo].[CSFSC]f  WHERE CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,f.[ENDDATE12])),0)) < GETDATE()
            ) ff ON ff.FSCYEAR >= YEAR(DATEADD(MONTH, -24, GETDATE()))
            WHERE
              il.LOCATION IN ('1','1L','10','10L','4D','5L')
              AND il.USED = 1
              AND il.ACTIVE = 1) q
        ) s
      WHERE [Fiscal Year] = YEAR(GETDATE()) AND [Fiscal Period] = MONTH(GETDATE()) -1
    SQL
  end
end
