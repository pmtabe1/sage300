json.array! @inv_vs_sales.each do |l|
  json.ItemCode l['ItemCode']
  json.Description l['Description']
  json.Loc l['Loc']
  json.Group l['Group']
  json.QtyAV l['QtyAV']
  json.QtyAve l['QtyAve']
  json.QtySO l['QtySO']
  json.QtyPO l['QtyPO']
  json.QtyPack l['QtyPack']
  json.Coverage l['Coverage']
  (0..11).map do |m|
    json.set! m.months.ago.end_of_month.strftime("%Y-%m"), l[m.months.ago.end_of_month.strftime("%Y-%m")]
  end
end
