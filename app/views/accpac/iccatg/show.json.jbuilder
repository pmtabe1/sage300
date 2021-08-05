json.array! @items.each do |item|
  json.itemno link_to(item.ITEMNO, item)
  json.formatted item.FMTITEMNO
  json.description item.DESC
  json.location item.LOCATION
  json.um item.STOCKUNIT
  json.available item.QTYAVAILAB.to_f
  json.on_hand item.QTYONHAND.to_f
  json.commit item.QTYCOMMIT.to_f
  json.recent_cost item.RECENTCOST.to_f
  json.amount item.AMOUNT.to_f
  json.sales_rank item.abc_sales_rank
  json.dense_sales item.dense_sales_rank.to_s
  json.packing item.PACKUNIT[0,30]
  json.properties item.PROPERTIES[0,30]
end
