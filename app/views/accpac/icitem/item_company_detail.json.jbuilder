json.array! @item_company_detail.each do |item|
  json.item item.FMTITEMNO
  json.description item.DESC
  json.category item.CDESC
  json.rank item.abc_sales_rank
  json.dense item.dense_sales_rank
  json.qty_on_hand item.QTYONHAND.to_f
  json.qty_commit item.QTYCOMMIT.to_f
  json.qty_sales_order item.QTYSALORDR.to_f
  json.qty_purchase_order item.QTYONORDER.to_f
  json.qty_production item.PRODUCTION.to_f
  json.qty_transfer_out item.TRANSFOUT.to_f
  json.qty_transfer_in item.TRANSFIN.to_f
  # Moving Average QTY
  json.stock_coverage item.COVERAGE.to_f
  json.projected_coverage item.PROJECTEDCOVER.to_f
  json.moving_ave_quantity_24 item.TOWYEARSQTY.to_f
  json.moving_ave_quantity_12 item.FOURQUARTERQTY.to_f
  json.moving_ave_quantity_9 item.THIRDQUARTERQTY.to_f
  json.moving_ave_quantity_6 item.SECONDQUARTERQTY.to_f
  json.moving_ave_quantity_3 item.FIRSTQUARTERQTY.to_f
  # Moving Average AMT
  json.moving_ave_amount_24 item.TOWYEARSAMT.to_f
  json.moving_ave_amount_12 item.FOURQUARTERAMT.to_f
  json.moving_ave_amount_9 item.THIRDQUARTERAMT.to_f
  json.moving_ave_amount_6 item.SECONDQUARTERAMT.to_f
  json.moving_ave_amount_3 item.FIRSTQUARTERAMT.to_f

  json.vendor1 item.VENDOR1
  json.vendor2 item.VENDOR2
  json.vendor3 item.VENDOR3
  json.vendor4 item.VENDOR4
  json.vendor5 item.VENDOR5
  json.vendor6 item.VENDOR6
end
