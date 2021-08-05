json.array! @drop_shipments.each do |purchase_order|
  json.porhseq purchase_order.PORHSEQ.to_i
  json.ponumber purchase_order.PONUMBER
  json.vendor_code purchase_order.VDCODE
  json.vendor_name purchase_order.VDNAME
  json.customer_code purchase_order.CUSTOMER
  json.customer_name purchase_order.BILNAME
  json.reference purchase_order.REFERENCE
  json.description purchase_order.DESCRIPTIO
  json.sonumber purchase_order.SONUMBER
  json.location purchase_order.LOCATION
  json.eta to_date_helper(purchase_order.EXPARRIVAL)
  json.order_amount purchase_order.INVNETWTX.to_f
end
