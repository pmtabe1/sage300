json.array! @sales_orders.each do |sales_order|
  json.ORDUNIQ sales_order.ORDUNIQ.to_i
  json.LOCATION sales_order.LOCATION
  json.QTYORDERED sales_order.QTYORDERED
  json.QTYSHIPPED sales_order.QTYSHIPPED
  json.ORDUNIT sales_order.ORDUNIT
  json.UNITPRICE sales_order.UNITPRICE.to_f
  json.QTYCOMMIT sales_order.QTYCOMMIT
  json.ORDNUMBER sales_order.ORDNUMBER
  json.CUSTOMER sales_order.CUSTOMER
  json.BILNAME sales_order.BILNAME
  json.ORD_DATE sales_order.ORD_DATE
  json.SALESPER1 sales_order.SALESPER1
  json.ORDTYPE sales_order.ORDTYPE
  json.ONHOLD sales_order.ONHOLD
end
