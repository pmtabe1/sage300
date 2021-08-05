json.array! @transactions.each do |transaction|
  json.LOCATION transaction.LOCATION
  json.FISCYEAR transaction.FISCYEAR
  json.FISCPERIOD transaction.FISCPERIOD
  case transaction.FISCPERIOD.to_s.length
  when 1
    json.FISCPERIOD "0#{transaction.FISCPERIOD}"
  else
    json.FISCPERIOD transaction.FISCPERIOD.to_s
  end
  json.DOCNUM transaction.DOCNUM
  json.APP transaction.APP
  json.QUANTITY transaction.QUANTITY.to_f
  json.UNIT transaction.UNIT
  # Costs
  json.SRCEXTCST transaction.SRCEXTCST.to_f # Home Cost
  json.HOMEEXTCST transaction.HOMEEXTCST.to_f # SOurce Cost
  json.AVGCOST avg_unit_cost(transaction)
  if transaction.TRANSDATE.present?
    json.TRANS_DATE to_date_helper(transaction.TRANSDATE)
  else
    json.TRANS_DATE ""
  end
  case transaction.TRANSTYPE
  when 1
    json.TRANS_TYPE 'Receipt'
  when 2
    json.TRANS_TYPE 'Receipt Adjustment'
  when 3
    json.TRANS_TYPE 'Receipt Return'
  when 4
    json.TRANS_TYPE 'Shipment'
  when 5
    json.TRANS_TYPE 'Shipment Return'
  when 6
    json.TRANS_TYPE 'Adjustment Quantity Increase'
  when 7
    json.TRANS_TYPE 'Adjustment Quantity Decrease'
  when 8
    json.TRANS_TYPE 'Adjustment Cost Increase'
  when 9
    json.TRANS_TYPE 'Adjustment Cost Decrease'
  when 10
    json.TRANS_TYPE 'Adjustment Both Increase'
  when 11
    json.TRANS_TYPE 'Adjustment Both Decrease'
  when 12
    json.TRANS_TYPE 'Stock Transfer From'
  when 13
    json.TRANS_TYPE 'Stock Trasnfer To'
  when 14
    json.TRANS_TYPE 'Master Item Assembly'
  when 15
    json.TRANS_TYPE 'Component Item Assembly'
  when 16
    json.TRANS_TYPE 'Invoice'
  when 17
    json.TRANS_TYPE 'Credit Note'
  when 18
    json.TRANS_TYPE 'Debit Note'
  when 19
    json.TRANS_TYPE 'Shipment Adjustment'
  else
    json.TRANS_TYPE 'Internal Usage'
  end
end
