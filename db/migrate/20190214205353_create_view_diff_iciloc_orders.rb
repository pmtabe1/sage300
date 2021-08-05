class CreateViewDiffIcilocOrders < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists DiffIcilocOrders 
    SQL

    execute <<-SQL
      CREATE VIEW DiffIcilocOrders AS
      SELECT
        dbo.ICILOC.ITEMNO, dbo.ICILOC.LOCATION, dbo.ICILOC.QTYSALORDR AS ORDERED_ICILOC,
        SUM(dbo.OEORDD.QTYORDERED) AS ORDERED_OE, dbo.ICILOC.QTYCOMMIT,
        SUM(dbo.OEORDD.QTYCOMMIT) AS ORDCOMMIT
      FROM dbo.ICILOC
      INNER JOIN dbo.OEORDD ON REPLACE(dbo.OEORDD.ITEM, '-', '') = dbo.ICILOC.ITEMNO
      INNER JOIN dbo.OEORDH ON dbo.OEORDD.ORDUNIQ = dbo.OEORDH.ORDUNIQ 
        AND dbo.ICILOC.LOCATION = dbo.OEORDD.LOCATION
        AND dbo.OEORDD.COMPLETE = 0
        AND dbo.OEORDH.TYPE = 1 AND dbo.OEORDH.ONHOLD = 0
      GROUP BY
        dbo.ICILOC.ITEMNO, dbo.ICILOC.LOCATION, dbo.ICILOC.QTYONORDER,
        dbo.ICILOC.QTYSALORDR, dbo.ICILOC.QTYONHAND, dbo.ICILOC.QTYCOMMIT
      HAVING (SUM(dbo.OEORDD.QTYORDERED) <> dbo.ICILOC.QTYSALORDR)
    SQL
  end
end
