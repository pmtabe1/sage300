class CreateViewOrderAction < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      drop view if exists OrderAction
    SQL

    execute <<-SQL
      CREATE VIEW OrderAction AS
      SELECT
        dbo.OpenOrders.ITEM, dbo.OpenOrders.[DESC], dbo.OpenOrders.ORDUNIQ, dbo.OpenOrders.ORDNUMBER,
        dbo.OpenOrders.LOCATION, dbo.OpenOrders.CUSTOMER, dbo.OpenOrders.CUSTNAME, dbo.OpenOrders.SALESREP,
        dbo.OpenOrders.ORDDATE, dbo.OpenOrders.QTYORDERED, dbo.OpenOrders.QTYCOMMIT, dbo.OpenOrders.ORDAMOUNT,
        dbo.OpenOrders.CUSTGROUP, dbo.OpenOrders.LOCSTOCK, dbo.OpenOrders.COMPSTOCK, dbo.OrdersMetric.BACKORDQTY,
        dbo.OrdersMetric.FULFILLQTY, dbo.OrdersMetric.OPENORDQTY, Granite.dbo.[Document].ShippingReference AS REFERENCE,
        dbo.OpenOrders.PONUMBER, dbo.OpenOrders.REFERENCE AS SOREFERENCE, dbo.OpenOrders.MRCAMOUNT,
            (
              SELECT id
              FROM dbo.shipping_references
              WHERE (number = Granite.dbo.[Document].ShippingReference COLLATE Latin1_General_BIN)
            ) AS REFID,
            (
              SELECT created_at
              FROM dbo.shipping_references AS shipping_references_2
              WHERE (number = Granite.dbo.[Document].ShippingReference COLLATE Latin1_General_BIN)
            ) AS REFDATE,
            (
              SELECT status
              FROM dbo.shipping_references AS shipping_references_1
              WHERE (number = Granite.dbo.[Document].ShippingReference COLLATE Latin1_General_BIN)
            ) AS REFSTATUS, dbo.ARCUS.CODECTRY, dbo.item_ranks.abc_sales_rank, dbo.item_ranks.dense_sales_rank, 
        dbo.item_ranks.abc_cost_rank, dbo.item_ranks.dense_cost_rank, dbo.item_ranks.abc_margin_rank,
        dbo.item_ranks.dense_margin_rank, dbo.ItemOptionalFields.OPTFCAT, dbo.ItemOptionalFields.OPTFDEPT, 
        dbo.ItemOptionalFields.OPTFPROD, dbo.ItemOptionalFields.OPTFTYPE, dbo.ItemOptionalFields.CATDESC,
        dbo.ItemOptionalFields.CATEGORY
      FROM  dbo.OpenOrders 
      INNER JOIN dbo.OrdersMetric ON dbo.OpenOrders.ITEM = dbo.OrdersMetric.ITEM
      INNER JOIN Granite.dbo.[Document] ON dbo.OpenOrders.ORDNUMBER = Granite.dbo.[Document].Number COLLATE Latin1_General_BIN
      INNER JOIN dbo.ARCUS ON dbo.OpenOrders.CUSTOMER = dbo.ARCUS.IDCUST
      INNER JOIN dbo.ItemOptionalFields ON dbo.OpenOrders.ITEM = dbo.ItemOptionalFields.FMTITEMNO
      LEFT OUTER JOIN dbo.item_ranks ON REPLACE(dbo.OpenOrders.ITEM, '-', '') = dbo.item_ranks.item
      GROUP BY dbo.OpenOrders.ITEM, dbo.OpenOrders.[DESC], dbo.OpenOrders.ORDUNIQ, dbo.OpenOrders.ORDNUMBER,
        dbo.OpenOrders.LOCATION, dbo.OpenOrders.CUSTOMER, dbo.OpenOrders.CUSTNAME, 
        dbo.OpenOrders.SALESREP, dbo.OpenOrders.ORDDATE, dbo.OpenOrders.QTYORDERED,
        dbo.OpenOrders.QTYCOMMIT, dbo.OpenOrders.ORDAMOUNT, dbo.OpenOrders.CUSTGROUP,
        dbo.OpenOrders.LOCSTOCK, dbo.OpenOrders.COMPSTOCK, dbo.OrdersMetric.BACKORDQTY,
        dbo.OrdersMetric.FULFILLQTY, dbo.OrdersMetric.OPENORDQTY, Granite.dbo.[Document].ShippingReference,
        dbo.ARCUS.CODECTRY, dbo.item_ranks.abc_sales_rank, dbo.item_ranks.dense_sales_rank,
        dbo.item_ranks.abc_cost_rank, dbo.item_ranks.dense_cost_rank, dbo.item_ranks.abc_margin_rank,
        dbo.item_ranks.dense_margin_rank, dbo.ItemOptionalFields.OPTFCAT, dbo.ItemOptionalFields.OPTFDEPT,
        dbo.ItemOptionalFields.OPTFPROD, dbo.ItemOptionalFields.OPTFTYPE, dbo.ItemOptionalFields.CATDESC, 
        dbo.ItemOptionalFields.CATEGORY, dbo.OpenOrders.PONUMBER, dbo.OpenOrders.REFERENCE, dbo.OpenOrders.MRCAMOUNT
    SQL
  end
end
