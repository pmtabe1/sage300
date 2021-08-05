json.array! @sales_history do |sales_history|
  json.item sales_history.ITEM
  json.formatted_item sales_history.FMTITEMNO
  json.description sales_history.DESC
  json.location sales_history.LOCATION
  json.sales_order sales_history.ORDNUMBER
  json.invoice sales_history.INVOICE
  json.year sales_history.YR
  json.period sales_history.PERIOD
  json.quantity sales_history.QTYSOLD.to_f
  if sales_history.QTYSOLD > 0
    json.price (sales_history.NETSALES/sales_history.QTYSOLD).to_f
  else
    json.price 0.00
  end
  json.net_sales sales_history.NETSALES.to_f
end
