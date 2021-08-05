SELECT
  open_orders.ITEM, open_orders.[DESC], open_orders.ORDUNIQ, open_orders.ORDNUMBER,
  open_orders.LOCATION, open_orders.CUSTOMER, open_orders.CUSTNAME, open_orders.SALESREP,
  open_orders.ORDDATE, open_orders.QTYORDERED, open_orders.QTYCOMMIT, open_orders.ORDAMOUNT,
  open_orders.CUSTGROUP, open_orders.LOCSTOCK, open_orders.COMPSTOCK, order_metrics.BACKORDQTY,
  order_metrics.FULFILLQTY, order_metrics.OPENORDQTY, GraniteMX.dbo.[Document].ShippingReference AS REFERENCE,
  open_orders.PONUMBER, open_orders.REFERENCE AS SOREFERENCE, open_orders.MRCAMOUNT, open_orders.ENTEREDBY,
      (
        SELECT id
        FROM dbo.shipping_references
        WHERE (number = GraniteMX.dbo.[Document].ShippingReference COLLATE Latin1_General_BIN)
      ) AS REFID,
      (
        SELECT created_at
        FROM dbo.shipping_references AS shipping_references_2
        WHERE (number = GraniteMX.dbo.[Document].ShippingReference COLLATE Latin1_General_BIN)
      ) AS REFDATE,
      (
        SELECT status
        FROM dbo.shipping_references AS shipping_references_1
        WHERE (number = GraniteMX.dbo.[Document].ShippingReference COLLATE Latin1_General_BIN)
      ) AS REFSTATUS, dbo.ARCUS.CODECTRY, items_rankings.abc_sales_rank, items_rankings.dense_sales_rank, 
  items_rankings.abc_cost_rank, items_rankings.dense_cost_rank, items_rankings.abc_margin_rank,
  items_rankings.dense_margin_rank, item_optional_fields.OPTFCAT, item_optional_fields.OPTFDEPT, 
  item_optional_fields.OPTFPROD, item_optional_fields.OPTFTYPE, item_optional_fields.CATDESC,
  item_optional_fields.CATEGORY
FROM  open_orders 
INNER JOIN order_metrics ON open_orders.ITEM = order_metrics.ITEM
INNER JOIN GraniteMX.dbo.[Document] ON open_orders.ORDNUMBER = GraniteMX.dbo.[Document].Number COLLATE Latin1_General_BIN
INNER JOIN dbo.ARCUS ON open_orders.CUSTOMER = dbo.ARCUS.IDCUST
INNER JOIN item_optional_fields ON open_orders.ITEM = item_optional_fields.FMTITEMNO
LEFT OUTER JOIN items_rankings ON REPLACE(open_orders.ITEM, '-', '') = items_rankings.item
GROUP BY open_orders.ITEM, open_orders.[DESC], open_orders.ORDUNIQ, open_orders.ORDNUMBER,
  open_orders.LOCATION, open_orders.CUSTOMER, open_orders.CUSTNAME, open_orders.ENTEREDBY,
  open_orders.SALESREP, open_orders.ORDDATE, open_orders.QTYORDERED,
  open_orders.QTYCOMMIT, open_orders.ORDAMOUNT, open_orders.CUSTGROUP,
  open_orders.LOCSTOCK, open_orders.COMPSTOCK, order_metrics.BACKORDQTY,
  order_metrics.FULFILLQTY, order_metrics.OPENORDQTY, GraniteMX.dbo.[Document].ShippingReference,
  dbo.ARCUS.CODECTRY, items_rankings.abc_sales_rank, items_rankings.dense_sales_rank,
  items_rankings.abc_cost_rank, items_rankings.dense_cost_rank, items_rankings.abc_margin_rank,
  items_rankings.dense_margin_rank, item_optional_fields.OPTFCAT, item_optional_fields.OPTFDEPT,
  item_optional_fields.OPTFPROD, item_optional_fields.OPTFTYPE, item_optional_fields.CATDESC, 
  item_optional_fields.CATEGORY, open_orders.PONUMBER, open_orders.REFERENCE, open_orders.MRCAMOUNT
