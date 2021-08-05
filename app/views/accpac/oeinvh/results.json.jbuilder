json.array! @invoices.each do |invoice|
  json.number link_to(invoice.INVNUMBER, print_accpac_oeinvh_path(id: invoice.INVUNIQ.to_i), target: "_blank")
  json.date to_date_helper(invoice.INVDATE)
  json.ponumber invoice.PONUMBER
  json.customer invoice.CUSTOMER
  json.bilname invoice.BILNAME
  json.location invoice.LOCATION
  json.shipvia invoice.VIADESC
  json.invoice_date invoice.INVDATE
  json.year invoice.INVFISCYR
  json.period invoice.INVFISCPER
  json.misc_charges invoice.INVMISC.to_f
  #json.item_total invoice.INVITMTOT.to_f
  json.total_amount invoice.INVAMOUNT.to_f
end
