json.array! @order_action_report.each do |sales_order|
  json.order_number sales_order.ORDNUMBER.strip!
  if sales_order.ORDDATE > 0
    json.order_date to_date_helper(sales_order.ORDDATE)
    json.days_order_open (Time.now.strftime("%Y-%m-%d").to_date - to_date_helper(sales_order.ORDDATE)).to_i
  else
    json.order_date ""
    json.days_order_open ""
  end
  json.customer_code sales_order.CUSTOMER
  json.customer_name sales_order.BILNAME
  json.country sales_order.CODECTRY
  json.sales_rep sales_order.SALESPER1
  json.item sales_order.ITEM
  json.description sales_order.DESC
  json.location sales_order.LOCATION
  case sales_order.TYPE
  when 1
    json.type "Active"
  when 2
    json.type "Future"
  when 3
    json.type "Standing"
  else
    json.type "Quote"
  end
  json.qty_backorder sales_order.QTYBACKORD.to_f
  json.qty_commit sales_order.QTYCOMMIT.to_f
  json.unit_price sales_order.UNITPRICE.to_f
  json.amount (sales_order.UNITPRICE * sales_order.QTYBACKORD).to_f
  json.unit_cost sales_order.UNITCOST.to_f
  json.recent_cost sales_order.MOSTREC.to_f
  json.avg_cost sales_order.AVGCOST.to_f
  json.gpm order_action_gp(sales_order).to_f
  json.total_location order_action_total_qty_location(sales_order).to_f
  json.location1 sales_order.Loc1.to_f
  json.location1l sales_order.Loc1L.to_f
  json.location10 sales_order.Loc10.to_f
  json.location10l sales_order.Loc10L.to_f
  json.location10m sales_order.Loc10M.to_f
  json.location5l sales_order.Loc5L.to_f
  json.location4d sales_order.Loc4D.to_f
  json.location2d sales_order.Loc2D.to_f
  json.location2m sales_order.Loc2M.to_f
  json.location9 sales_order.Loc9.to_f
  json.location12 sales_order.Loc12.to_f
end
