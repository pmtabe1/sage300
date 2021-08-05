class CreateViewLocationDiff < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists LocationDiff
    SQL

    execute <<-SQL
      CREATE VIEW LocationDiff AS
      SELECT
        i.FMTITEMNO, i.[DESC], l.ITEMNO, l.LOCATION, l.QTYSALORDR,
        l.QTYCOMMIT, l.AUDTDATE,
        (
          SELECT ISNULL(SUM(od.QTYORDERED), 0.0000)
          FROM OEORDD od
          JOIN OEORDH oh ON od.ORDUNIQ = oh.ORDUNIQ
          WHERE od.LOCATION = l.LOCATION AND od.ITEM = i.FMTITEMNO
          AND od.COMPLETE = 0
          AND oh.TYPE = 1
          AND oh.ONHOLD = 0
        ) ORDEREDOE,
        (
          SELECT ISNULL(SUM(od.QTYCOMMIT), 0.0000)
          FROM OEORDD od
          JOIN OEORDH oh ON od.ORDUNIQ = oh.ORDUNIQ
          WHERE od.LOCATION = l.LOCATION AND od.ITEM = i.FMTITEMNO
          AND od.COMPLETE = 0
          AND oh.TYPE = 1
          AND oh.ONHOLD = 0
        ) AS ORDCOMMIT
      FROM dbo.ICILOC l
      LEFT JOIN dbo.ICITEM i ON l.ITEMNO = i.ITEMNO
      GROUP BY
        l.ITEMNO, i.ITEMNO, i.FMTITEMNO, i.[DESC], l.LOCATION,
        l.QTYONORDER, l.QTYSALORDR, l.QTYONHAND, l.QTYCOMMIT, l.AUDTDATE
    SQL
  end
end
