json.array! @miscellaneous_charges.each do |charge|
  json.customer charge.CUSTOMER
  json.customer_name charge.BILNAME
  json.invoice charge.INVNUMBER
  json.location charge.LOCATION
  json.territory charge.TERRITORY
  json.state charge.SHPSTATE
  json.country charge.SHPCOUNTRY
  json.shipvia charge.SHIPVIA
  json.year charge.INVFISCYR
  json.period charge.INVFISCPER
  json.charge_code charge.MISCCHARGE
  json.description charge.DESC
  json.acount charge.MISCACCT
  json.amount charge.EXTINVMISC.to_f
  json.sales_person charge.SALESPER1
end
