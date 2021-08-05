json.array! @purchase_orders_history.each do |purchase_order|
  json.item item_link(purchase_order.ITEMNO)
  json.formatted_item purchase_order.FMTITEMNO
  json.description purchase_order.DESCRIPTION
  json.ranking purchase_order.abc_sales_rank
  json.year purchase_order.FISCYEAR
  json.period purchase_order.FISCPERIOD
  json.date purchase_order.TRANSDATE.to_s.to_date
  case purchase_order.TRANSTYPE
  when 1
    json.type "Requisition"
  when 2
    json.type "Purchase Order"
  when 3
    json.type "Receipt"
  when 4
    json.type "Return"
  when 5
    json.type "Invoice"
  when 6
    json.type "Credit Note"
  when 7
    json.type "Debit Note"
  end
  json.number purchase_order.DOCNUMBER
  json.location purchase_order.LOCATION
  json.quantity purchase_order.RQPOSTED
  json.uom purchase_order.UNIT
  json.total_cost purchase_order.FCTOTAL
end
