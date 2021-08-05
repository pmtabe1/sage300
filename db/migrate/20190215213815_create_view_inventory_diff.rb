class CreateViewInventoryDiff < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists InventoryDiff
    SQL

    execute <<-SQL
    CREATE VIEW InventoryDiff AS
      SELECT
        TOP (100) PERCENT dbo.ICILOC.ITEMNO, dbo.ICITEM.FMTITEMNO, dbo.ICITEM.[DESC], 
        dbo.ICILOC.LOCATION, dbo.ICILOC.COSTUNIT, dbo.ICILOC.QTYONHAND, dbo.ICILOC.QTYCOMMIT, 
        dbo.ICILOC.QTYONHAND - dbo.ICILOC.QTYCOMMIT AS AVAILABLE, 
        CASE 
          WHEN
          SUM(Granite.dbo.App_Inventory_ByLocation.Qty) IS NULL THEN 0.00
          ELSE SUM(Granite.dbo.App_Inventory_ByLocation.Qty)
        END AS QTYGRANIT,
        dbo.ICILOC.QTYSALORDR, dbo.ICILOC.QTYONORDER, dbo.ICILOC.LASTSHIPDT, dbo.ICILOC.LASTRCPTDT, dbo.ICILOC.LASTCOST,
        dbo.ItemsRanking.abc_sales_rank, dbo.ItemsRanking.dense_sales_rank,
        (
          SELECT LTRIM(RTRIM(VALUE))
          FROM dbo.ICITEMO AS o
          WHERE (ICILOC.ITEMNO = ITEMNO) AND (OPTFIELD = 'DEPT')
        ) AS OPTFDEP
      FROM dbo.ICILOC
      FULL OUTER JOIN
        Granite.dbo.App_Inventory_ByLocation ON dbo.ICILOC.ITEMNO COLLATE DATABASE_DEFAULT = Granite.dbo.App_Inventory_ByLocation.Code COLLATE DATABASE_DEFAULT AND  
        dbo.ICILOC.LOCATION COLLATE DATABASE_DEFAULT = Granite.dbo.App_Inventory_ByLocation.ERPLocation COLLATE DATABASE_DEFAULT
      FULL OUTER JOIN dbo.ICITEM ON dbo.ICILOC.ITEMNO = dbo.ICITEM.ITEMNO
      FULL OUTER JOIN dbo.ItemsRanking ON dbo.ICILOC.ITEMNO = dbo.ItemsRanking.item
      WHERE dbo.ICILOC.LOCATION IS NOT NULL
      GROUP BY
        dbo.ICILOC.ITEMNO, dbo.ICILOC.LOCATION, dbo.ICILOC.QTYONHAND, dbo.ICILOC.QTYCOMMIT, dbo.ICILOC.QTYSALORDR, 
        dbo.ICILOC.QTYONORDER, dbo.ICILOC.DAYSTOSHIP, dbo.ICILOC.LASTSHIPDT, dbo.ICILOC.LASTRCPTDT, dbo.ICILOC.LASTCOST,
        dbo.ICITEM.[DESC], dbo.ICILOC.COSTUNIT, dbo.ItemsRanking.abc_sales_rank, dbo.ItemsRanking.dense_sales_rank, 
        dbo.ICITEM.FMTITEMNO
      ORDER BY dbo.ICILOC.ITEMNO
    SQL
  end
end
