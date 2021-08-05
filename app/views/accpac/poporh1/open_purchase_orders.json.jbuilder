json.array! @open_purchase_orders.each do |purchase_order|
  json.porhseq purchase_order.PORHSEQ.to_i
  json.line_number purchase_order.PORLREV
  json.line_seq purchase_order.PORLSEQ
  json.ponumber purchase_order.PONUMBER
  json.vendor_code purchase_order.VDCODE
  json.vendor_name purchase_order.VDNAME
  json.item_code purchase_order.ITEMNO
  json.location purchase_order.LOCATION
  json.date to_date_helper(purchase_order.DATE)
  json.year to_date_helper(purchase_order.DATE).strftime("%Y")
  json.days_open (Time.now.strftime("%Y-%m-%d").to_date - to_date_helper(purchase_order.DATE)).to_i
  if purchase_order.ETA.present?
    json.eta purchase_order.ETA
  else
    json.eta ""
  end
  json.qty_ordered purchase_order.OQORDERED.to_f
  json.qty_received purchase_order.OQRECEIVED.to_f
  json.qty_outstanding purchase_order.OQOUTSTAND.to_f
  json.qty_production purchase_order.PRODUCTION.to_f
  json.unit_cost purchase_order.UNITCOST
  json.ext_cost purchase_order.EXTENDED.to_f
  json.etd purchase_order.ETD
  json.qty_packed purchase_order.PACKED.to_f
  if purchase_order.PACKDATE.present?
    json.packed_date purchase_order.PACKDATE.strftime("%Y-%m-%d")
  else
    json.packed_date ""
  end
  if purchase_order.ONBOARD.present?
    json.onboard purchase_order.ONBOARD.to_date
  else
    json.onboard ""
  end
  json.container purchase_order.CONTAINER
  json.entered_by purchase_order.ENTEREDBY
end
