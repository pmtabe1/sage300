json.array! @moving_average.each do |item|
  json.item item.ITEMNO
  #json.description item.DESC
  #json.category item.CATDESC
  json.location item.LOCATION
  #json.sales_rank item.SALESRANK
  #json.dense_sales_rank item.DENSESALESRANK
  #json.qty_on_hand item.QTYONHAND
  #json.qty_sales_order item.QTYSALORDR
  #json.qty_purchase_order item.QTYONORDER
  #json.qty_commit item.QTYCOMMIT
  json.moving_ave_quantity_24 item.TOWYEARSQTY
  json.moving_ave_quantity_12 item.FOURQUARTERQTY
  json.moving_ave_quantity_9 item.THIRDQUARTERQTY
  json.moving_ave_quantity_6 item.SECONDQUARTERQTY
  json.moving_ave_quantity_3 item.FIRSTQUARTERQTY
end
