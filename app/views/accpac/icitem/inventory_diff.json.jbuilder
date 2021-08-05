json.array! @difference.each do |item|
  json.item item.FMTITEMNO
  json.dept item.OPTFDEP
  json.description item.DESC
  json.sales_rank item.abc_sales_rank
  json.location item.LOCATION
  json.uom item.COSTUNIT
  json.qty_on_hand item.QTYONHAND.to_f
  json.qty_commit item.QTYCOMMIT.to_f
  json.qty_available item.AVAILABLE.to_f
  json.qty_granite item.QTYGRANIT.to_f
  json.qty_diff (item.QTYGRANIT - item.AVAILABLE).to_f
  json.amnt_diff ((item.QTYGRANIT - item.AVAILABLE)*item.LASTCOST).to_f
  json.qty_sales_order item.QTYSALORDR.to_f
  json.qty_purchase_order item.QTYONORDER.to_f
  if item.LASTSHIPDT > 0
    json.last_ship_date to_date_helper(item.LASTSHIPDT)
  else
    json.last_ship_date ""
  end
  if item.LASTRCPTDT > 0
    json.last_recpt_date to_date_helper(item.LASTRCPTDT)
  else
    json.last_recpt_date ""
  end
end
