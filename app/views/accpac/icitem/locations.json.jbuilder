json.array! @locations.each do |location|
  json.LOCATION location.LOCATION
  json.sales_rank location.abc_sales_rank
  json.dense_sales_rank location.dense_sales_rank
  json.QTYONHAND location.QTYONHAND.to_f
  json.QTYSALORD location.QTYSALORDR.to_f
  json.QTYONORDER location.QTYONORDER.to_f
  json.QTYCOMMIT location.QTYCOMMIT.to_f
  json.RECENTCOST location.RECENTCOST.to_f
  json.TOTALCOST location.TOTALCOST.to_f
  json.LAST_SHIPDT location.LAST_SHIPDT
  json.LAST_RCPTDT location.LAST_RCPTDT
  json.AVAILABLE location.AVAILABLE.to_f
  json.DAYTOSHIP location.DAYSTOSHIP.to_f
  json.UNITSSHIP location.UNITSSHIP.to_f
  json.STDCOST location.STDCOST.to_f
  json.LASTCOST location.LASTCOST.to_f
  json.TRANSOUT location.TRANSOUT.to_f
  json.TRANSIN location.TRANSIN.to_f
  json.ITEMNO location.ITEMNO
  json.moving_ave_quantity_24 location.TOWYEARSQTY.to_f
  json.moving_ave_quantity_12 location.FOURQUARTERQTY.to_f
  json.moving_ave_quantity_9 location.THIRDQUARTERQTY.to_f
  json.moving_ave_quantity_6 location.SECONDQUARTERQTY.to_f
  json.moving_ave_quantity_3 location.FIRSTQUARTERQTY.to_f
  json.granite_locations Granite::MasterItemLocation.where(Code: params[:id], ERPLocation: location.LOCATION).where.not(QTY: 0).each do |granite|
    json.(granite, :Location, :Qty, :Site)
  end
end
