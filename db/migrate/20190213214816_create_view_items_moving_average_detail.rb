class CreateViewItemsMovingAverageDetail < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists ItemsMovingAveDetail
    SQL

    execute <<-SQL
      CREATE VIEW ItemsMovingAveDetail AS
      SELECT
        ItemOptionalFields.ITEMNO, ItemOptionalFields.FMTITEMNO, ItemOptionalFields.[DESC],
        ItemOptionalFields.CATEGORY, ItemOptionalFields.CATDESC,
        ItemsMovingAve.LOCATION, abc_sales_rank AS SALESRANK, dense_sales_rank AS DENSESALESRANK,
        ICILOC.QTYONHAND, ICILOC.QTYSALORDR, ICILOC.QTYONORDER, ICILOC.QTYCOMMIT,
        ItemsMovingAve.TOWYEARSQTY, ItemsMovingAve.FOURQUARTERQTY,
        ItemsMovingAve.THIRDQUARTERQTY, ItemsMovingAve.SECONDQUARTERQTY,
        ItemsMovingAve.FIRSTQUARTERQTY
      FROM ItemsMovingAve
      JOIN ItemOptionalFields ON ItemsMovingAve.ITEMNO = ItemOptionalFields.ITEMNO COLLATE DATABASE_DEFAULT
      JOIN ICILOC ON ItemsMovingAve.ITEMNO = ICILOC.ITEMNO AND ItemsMovingAve.LOCATION = ICILOC.[LOCATION] COLLATE DATABASE_DEFAULT
      LEFT JOIN item_ranks ON item = ItemsMovingAve.ITEMNO COLLATE DATABASE_DEFAULT
    SQL
  end
end
