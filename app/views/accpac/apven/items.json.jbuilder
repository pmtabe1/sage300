json.array! @items.each do |item|
  json.item item_link(item.ITEMNO)
  json.code item.FMTITEMNO
  json.description item.DESCRIPTION
  json.ranking item.abc_sales_rank
  json.vendor_code item.VENDITEM
  json.uom item.COSTUNIT
  case item.VENDTYPE
  when 1
    json.type "Vendor 1"
  when 2
    json.type "Vendor 2"
  when 3
    json.type "Vendor 3"
  when 4
    json.type "Vendor 4"
  when 5
    json.type "Vendor 5"
  when 6
    json.type "Vendor 6"
  when 7
    json.type "Vendor 7"
  when 8
    json.type "Vendor 8"
  when 9
    json.type "Vendor 9"
  end
  json.cost item.VENDCOST
  json.currency item.VENDCNCY
  if item.AUDTDATE > 0
    json.date to_date_helper(item.AUDTDATE)
  else
    json.date ""
  end
  json.user item.AUDTUSER
end
