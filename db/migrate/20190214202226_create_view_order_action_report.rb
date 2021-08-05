class CreateViewOrderActionReport < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists OrderActionReport
    SQL

    execute <<-SQL
      CREATE VIEW OrderActionReport AS
      SELECT
        dbo.OEORDD.ORDUNIQ, dbo.OEORDH.ORDNUMBER, dbo.OEORDH.CUSTOMER,
        dbo.OEORDH.BILNAME, dbo.ARCUS.CODECTRY, dbo.OEORDH.SALESPER1,
        dbo.OEORDH.CUSTGROUP, dbo.OEORDH.ORDDATE, dbo.OEORDD.ITEM,
        dbo.OEORDD.[DESC], dbo.OEORDD.QTYBACKORD, dbo.OEORDD.QTYCOMMIT,
        dbo.OEORDD.LOCATION, dbo.OEORDD.UNITPRICE, dbo.OEORDD.UNITCOST, 
        dbo.OEORDD.MOSTREC, dbo.OEORDD.AVGCOST, dbo.OnHandPivot.Loc1,
        dbo.OnHandPivot.Loc1L, dbo.OnHandPivot.Loc10L, dbo.OnHandPivot.Loc10,
        dbo.OnHandPivot.Loc5L, dbo.OnHandPivot.Loc4D, dbo.OnHandPivot.Loc2D,
        dbo.OnHandPivot.Loc2M, dbo.OnHandPivot.Loc10M, dbo.OnHandPivot.Loc9,
        dbo.OnHandPivot.Loc12, dbo.OEORDH.TYPE
      FROM dbo.OEORDD
      INNER JOIN dbo.OEORDH ON dbo.OEORDH.ORDUNIQ = dbo.OEORDD.ORDUNIQ
      INNER JOIN dbo.OnHandPivot ON dbo.OnHandPivot.ITEMNO = REPLACE(dbo.OEORDD.ITEM, '-', '')
      INNER JOIN dbo.ARCUS ON dbo.OEORDH.CUSTOMER = dbo.ARCUS.IDCUST
      WHERE (dbo.OEORDD.COMPLETE = 0)
    SQL
  end
end
