class CreateViewItemLocationDetail < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists ItemLocationDetail
    SQL

    execute <<-SQL
      CREATE VIEW ItemLocationDetail AS
      SELECT
        k.ITEMNO AS ITEMNO, i.FMTITEMNO, i.[DESC], k.LOCATION AS LOCATION, il.QTYONHAND AS QTYONHAND, c.CATEGORY,
        il.QTYCOMMIT AS QTYCOMMIT, il.QTYSALORDR AS QTYSALORDR, il.QTYONORDER AS QTYONORDER, ir.abc_sales_rank,
            il.RECENTCOST, (il.QTYONHAND*il.RECENTCOST) AS MRAMOUNT, il.TOTALCOST,
        ma.TOWYEARSQTY, ma.FOURQUARTERQTY, ma.THIRDQUARTERQTY, ma.SECONDQUARTERQTY, ma.FIRSTQUARTERQTY,
        ma.TOWYEARSAMT, ma.FOURQUARTERAMT, ma.THIRDQUARTERAMT, ma.SECONDQUARTERAMT, ma.FIRSTQUARTERAMT, 
        c.[DESC] AS CDESC, ((ma.TOWYEARSQTY+ma.FOURQUARTERQTY+ma.THIRDQUARTERQTY+ma.SECONDQUARTERQTY+ma.FIRSTQUARTERQTY)/4) AS AVERAGE

        ,ISNULL(CASE (ma.FOURQUARTERQTY+ma.THIRDQUARTERQTY+ma.SECONDQUARTERQTY+ma.FIRSTQUARTERQTY)
            WHEN 0 THEN 0.00
            ELSE ((QTYONHAND - QTYCOMMIT)/((ma.FOURQUARTERQTY+ma.THIRDQUARTERQTY+ma.SECONDQUARTERQTY+ma.FIRSTQUARTERQTY)/4))
        END,0.0) AS COVERAGE

        ,ISNULL(CASE k.LOCATION
            WHEN '1'    THEN (SELECT p.QTYONORDER FROM dbo.ICILOC p WHERE p.ITEMNO = k.ITEMNO AND p.LOCATION = '99')
            WHEN '1L'   THEN (SELECT p.QTYONORDER FROM dbo.ICILOC p WHERE p.ITEMNO = k.ITEMNO AND p.LOCATION = '991L')
            WHEN '10'   THEN (SELECT p.QTYONORDER FROM dbo.ICILOC p WHERE p.ITEMNO = k.ITEMNO AND p.LOCATION = '99E')
            WHEN '10L'  THEN (SELECT p.QTYONORDER FROM dbo.ICILOC p WHERE p.ITEMNO = k.ITEMNO AND p.LOCATION = '99L')
            WHEN '4D'   THEN (SELECT p.QTYONORDER FROM dbo.ICILOC p WHERE p.ITEMNO = k.ITEMNO AND p.LOCATION = '994D')
            WHEN '5L'   THEN (SELECT p.QTYONORDER FROM dbo.ICILOC p WHERE p.ITEMNO = k.ITEMNO AND p.LOCATION = '995L')
            ELSE 0.00
        END,0.0) AS PRODUCTION

        ,ISNULL((SELECT SUM(ICTRED.QTYREQ) FROM dbo.ICTREH
            JOIN dbo.ICTRED ON ICTRED.TRANFENSEQ = ICTREH.TRANFENSEQ
            WHERE ICTREH.STATUS <> 20
            AND ITEMNO = FMTITEMNO
            AND ICTRED.FROMLOC = k.LOCATION
            GROUP BY ICTRED.ITEMNO, ICTRED.FROMLOC),0.0) AS TRANSFOUT
            
        ,ISNULL((SELECT SUM(ICTRED.QTYREQ) FROM dbo.ICTREH
            JOIN dbo.ICTRED ON ICTRED.TRANFENSEQ = ICTREH.TRANFENSEQ
            WHERE ICTREH.STATUS <> 20
            AND ITEMNO = FMTITEMNO
            AND ICTRED.TOLOC = k.LOCATION
            GROUP BY ICTRED.ITEMNO, ICTRED.TOLOC),0.0) AS TRANSFIN

        ,MAX(CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,il.[LASTSHIPDT])),0))) AS LASTSHIPDT
        ,MAX(CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,il.[LASTRCPTDT])),0))) AS LASTRCPTDT

            -- Optional Fields
            ,(
                SELECT LTRIM(RTRIM(VALUE))
                FROM ICITEMO AS o
                WHERE (k.ITEMNO = o.ITEMNO) AND (OPTFIELD = 'CATEGORY')
            ) AS OPTFCAT
            ,(
                SELECT LTRIM(RTRIM(VALUE))
                FROM ICITEMO AS o
                WHERE (k.ITEMNO = o.ITEMNO) AND (OPTFIELD = 'DEPT')
            ) AS OPTFDEP
            ,(
                SELECT LTRIM(RTRIM(VALUE))
                FROM ICITEMO AS o
                WHERE (k.ITEMNO = o.ITEMNO) AND (OPTFIELD = 'PRODUCT')
            ) AS OPTFPROD
            ,(
                SELECT LTRIM(RTRIM(VALUE))
                FROM ICITEMO AS o
                WHERE (k.ITEMNO = o.ITEMNO) AND (OPTFIELD = 'TYPE')
            ) AS OPTFTYPE
            ,(
                SELECT LTRIM(RTRIM(VALUE))
                FROM ICITEMO AS o
                WHERE (k.ITEMNO = o.ITEMNO) AND (OPTFIELD = 'SUBFAMILY')
            ) AS SUBFAMILY

            -- Vendors
        ,ISNULL((
            SELECT VENDNUM
            FROM ICITMV iv
            WHERE k.ITEMNO = iv.ITEMNO AND VENDTYPE = 1
        ), NULL) AS VENDOR1
        ,ISNULL((
            SELECT VENDNUM
            FROM ICITMV iv
            WHERE k.ITEMNO = iv.ITEMNO AND VENDTYPE = 2
        ), NULL) AS VENDOR2
        ,ISNULL((
            SELECT VENDNUM
            FROM ICITMV iv
            WHERE k.ITEMNO = iv.ITEMNO AND VENDTYPE = 3
        ), NULL) AS VENDOR3
        ,ISNULL((
            SELECT VENDNUM
            FROM ICITMV iv
            WHERE k.ITEMNO = iv.ITEMNO AND VENDTYPE = 4
        ),NULL) AS VENDOR4
        ,ISNULL((
            SELECT VENDNUM
            FROM ICITMV iv
            WHERE k.ITEMNO = iv.ITEMNO AND VENDTYPE = 5
        ), NULL) AS VENDOR5
        ,ISNULL((
            SELECT VENDNUM
            FROM ICITMV iv
            WHERE k.ITEMNO = iv.ITEMNO AND VENDTYPE = 6
        ), NULL) AS VENDOR6

      FROM
        (
          SELECT iss.ITEMNO, iss.LOCATION, iss.YEAR, iss.PERIOD
          FROM dbo.ICSTATI iss
          --WHERE iss.YEAR > YEAR(DATEADD(MONTH, -36, GETDATE()))
          --AND iss.LOCATION IN ('1','1L','10','10L','4D','5L')
        ) k
      JOIN dbo.ICILOC il ON k.ITEMNO = il.ITEMNO AND k.LOCATION = il.LOCATION
      JOIN dbo.ICITEM i ON k.ITEMNO = i.ITEMNO
      JOIN dbo.ICCATG c ON i.CATEGORY = c.CATEGORY

      LEFT JOIN ItemsMovingAve ma ON il.ITEMNO = ma.ITEMNO AND il.[LOCATION] = ma.[LOCATION]
      LEFT JOIN ItemsRankingLocation ir ON il.ITEMNO = ir.item AND il.LOCATION = ir.[location]

      GROUP BY
        k.ITEMNO, k.LOCATION, il.QTYONHAND ,il.QTYCOMMIT, il.QTYSALORDR, il.QTYONORDER, il.RECENTCOST, il.TOTALCOST,
        i.FMTITEMNO, i.[DESC], ir.abc_sales_rank, ma.TOWYEARSQTY ,ma.FOURQUARTERQTY,
        ma.THIRDQUARTERQTY, ma.SECONDQUARTERQTY, ma.FIRSTQUARTERQTY, c.CATEGORY, c.[DESC],
        ma.TOWYEARSAMT, ma.FOURQUARTERAMT, ma.THIRDQUARTERAMT, ma.SECONDQUARTERAMT, ma.FIRSTQUARTERAMT

    SQL
  end
end

