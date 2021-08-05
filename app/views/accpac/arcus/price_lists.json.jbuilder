json.array! @price_lists do |price_list|
  json.item item_link(price_list.ITEMNO)
  json.formatted_item price_list.FMTITEMNO
  json.description price_list.DESC
  json.customer_item price_list.CITEMNO
  json.customer_description price_list.CITEMDESC
  json.commodity price_list.COMMODIM
  case price_list.DPRICETYPE
  when 1
    json.type "Base Price Quantity"
  when 2
    json.type "Sale Price Quantity"
  when 3
    json.type "Base Price Weight"
  when 4
    json.type "Sale Price Weight"
  when 5
    json.type "Base Price Using Cost"
  when 6
    json.type "Sale Price Using Cost"
  end
  json.qty_unit price_list.QTYUNIT
  json.date to_date_helper(price_list.AUDTDATE)
  json.user price_list.AUDTUSER
  json.unit_price price_list.UNITPRICE.to_f
  if price_list.LASTPRICDT > 0
    json.updated_at to_date_helper(price_list.LASTPRICDT)
  else
    ""
  end
  json.previous_price price_list.PREVPRICE.to_f
end
