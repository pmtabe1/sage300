json.array! @opened_purchases.each do |purchase_order|
  json.number purchase_order_link(purchase_order.PORHSEQ.to_i, purchase_order.PONUMBER)
  if purchase_order.DATE > 0
    json.date to_date_helper(purchase_order.DATE)
  else
    json.date ""
  end
  json.days_open (Time.now.strftime("%Y-%m-%d").to_date - to_date_helper(purchase_order.DATE)).to_i
  #json.location purchase_order.LOCATION
  json.fob purchase_order.FOBPOINT
  if purchase_order.ORDEREDON > 0
    json.order_date to_date_helper(purchase_order.ORDEREDON)
  else
    json.order_date ""
  end
  if purchase_order.EXPARRIVAL > 0
    json.eta to_date_helper(purchase_order.EXPARRIVAL)
  else
    json.eta ""
  end
  json.description purchase_order.DESCRIPTIO
  json.reference purchase_order.REFERENCE
  json.shipvia purchase_order.VIANAME
  json.currency purchase_order.CURRENCY
  json.rate purchase_order.RATE
  json.amount purchase_order.FCAMOUNT.to_f
end
