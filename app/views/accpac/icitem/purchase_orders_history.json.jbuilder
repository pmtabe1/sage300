json.array! @purchase_orders_history.each do |purchase_order|
  if can? :read, Accpac::Apven
    json.VENDOR purchase_order.VENDOR
    json.VENDNAME purchase_order.VENDNAME
  else
    json.VENDOR "NaN"
    json.VENDNAME "NaN"
  end
  json.LOCATION purchase_order.LOCATION
  json.FISCYEAR purchase_order.FISCYEAR
  case purchase_order.FISCPERIOD.to_s.length
  when 1
    json.FISCPERIOD "0#{purchase_order.FISCPERIOD}"
  else
    json.FISCPERIOD purchase_order.FISCPERIOD.to_s
  end
  if purchase_order.TRANSDATE > 0
    json.TRANS_DATE to_date_helper(purchase_order.TRANSDATE)
  else
    json.TRANS_DATE ""
  end
  case purchase_order.TRANSTYPE
  when 1
    json.TRANS_TYPE 'Requisition'
  when 2
    json.TRANS_TYPE 'Purchase Order'
  when 3
    json.TRANS_TYPE 'Receipt'
  when 4
    json.TRANS_TYPE 'Return'
  when 5
    json.TRANS_TYPE 'Invoice'
  when 6
    json.TRANS_TYPE 'Credit Note'
  else
    json.TRANS_TYPE 'Debit Note'
  end
  json.DOCNUMBER purchase_order.DOCNUMBER
  json.UNIT purchase_order.UNIT
  json.RQPOSTED purchase_order.RQPOSTED.to_f
  if can? :read, Accpac::Apven
    json.UNITCOST (purchase_order.SCEXTENDED/purchase_order.RQPOSTED).to_f
    json.SCEXTENDED purchase_order.SCEXTENDED.to_f
  else
    json.UNITCOST "NaN"
    json.SCEXTENDED "NaN"
  end
end
