json.array! @purchase_orders.each do |purchase_order|
  json.ponumber purchase_order.PONUMBER
  if can? :read, Accpac::Apven
    json.vendor_code purchase_order.VDCODE
    json.vendor_name purchase_order.VDNAME
  else
    json.vendor_code "NaN"
    json.vendor_name "NaN"
  end
  json.reference purchase_order.REFERENCE
  json.date purchase_order.PD_DATE
  json.location purchase_order.LOCATION
  json.uom purchase_order.ORDERUNIT
  if can? :read, Accpac::Apven
    json.unit_cost purchase_order.UNITCOST
    json.ext_cost purchase_order.EXTENDED
  else
    json.unit_cost "NaN"
    json.ext_cost "NaN"
  end
  json.qty_ordered purchase_order.OQORDERED
  json.qty_outstanding purchase_order.SQOUTSTAND
  json.eta purchase_order.EXP_ARRIVAL
  json.type purchase_order.PORTYPE
  json.on_hold purchase_order.ONHOLD
  json.documents shipping_documents(purchase_order.PORHSEQ, purchase_order.ITEMNO).each do |document|
    json.type document.name
    json.document document.id
    json.quantity document.quantity
    json.date document.updated_at.to_date
    json.etd document.etd
    json.obd document.obd
    json.eta document.eta
    json.container document.container
  end
end
