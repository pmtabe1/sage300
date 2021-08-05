json.array! @sales_history.each do |sales_order|
  json.CUSTOMER sales_order.CUSTOMER
  json.NAMECUST sales_order.NAMECUST
  json.LOCATION sales_order.LOCATION
  json.YR sales_order.YR
  case sales_order.PERIOD.to_s.length
  when 1
    json.PERIOD "0#{sales_order.PERIOD}"
  else
    json.PERIOD sales_order.PERIOD.to_s
  end
  json.ORDNUMBER sales_order.ORDNUMBER
  if sales_order.ORDDATE > 0
    json.ORD_DATE to_date_helper(sales_order.ORDDATE)
  else
    json.ORD_DATE ""
  end
  if sales_order.SHIPDATE > 0
    json.SHIP_DATE to_date_helper(sales_order.SHIPDATE)
  else
    json.SHIP_DATE ""
  end
  json.SHINUMBER sales_order.SHINUMBER
  json.TERRITORY sales_order.TERRITORY
  json.QTYSOLD sales_order.QTYSOLD.to_f
  json.UNITPRIC (sales_order.FAMTSALES/sales_order.QTYSOLD).to_f
  json.FAMTSALES sales_order.FAMTSALES.to_f
end
