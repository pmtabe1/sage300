class CreateViewOrdersMetric < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists OrdersMetric
    SQL

    execute <<-SQL
      CREATE VIEW OrdersMetric AS
      SELECT ITEM, SUM(QTYORDERED) AS OPENORDQTY, COMPSTOCK AS STOCKQTY, SUM(QTYCOMMIT) AS COMMITQTY, 
        CASE 
          WHEN COMPSTOCK - SUM(QTYORDERED - QTYCOMMIT) < 0
          THEN (SUM(QTYORDERED - QTYCOMMIT)) - COMPSTOCK
          ELSE 0.00
        END AS BACKORDQTY, 

        CASE 
          WHEN (COMPSTOCK - SUM(QTYORDERED)) > 0
          THEN SUM(QTYORDERED)
          ELSE COMPSTOCK
        END AS FULFILLQTY
      FROM dbo.OpenOrders
      GROUP BY ITEM, COMPSTOCK
    SQL
  end
end
