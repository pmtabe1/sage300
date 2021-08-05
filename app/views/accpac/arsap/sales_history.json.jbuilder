json.array! @sales_history do |sales_history|
  json.item sales_history.ITEM
  json.description sales_history.DESCRIPTION
  json.customer_code sales_history.CUSTOMER
  json.customer_name sales_history.NAMECUST
  json.order_number sales_history.ORDNUMBER
  json.po_number sales_history.PONUMBER
  json.location sales_history.LOCATION
  json.year sales_history.YR
  json.period sales_history.PERIOD
  json.quantity sales_history.QTYSOLD
  json.amount sales_history.FAMTSALES
end
