json.array! @transfer_demand.each do |sales_order|
  json.order_number sales_order.ORDNUMBER #order_link(sales_order.ORDUNIQ, sales_order.ORDNUMBER.strip)
  if sales_order.REFERENCE.present?
    json.reference sales_order.REFERENCE #reference_link(sales_order.REFID, sales_order.REFERENCE)
    json.reference_date sales_order.REFDATE.to_date
    json.days_order_process (Time.now.strftime("%Y-%m-%d").to_date - sales_order.REFDATE.to_date).to_i
    json.reference_status sales_order.REFSTATUS
    if sales_order.BACKORDQTY > 0
      json.status "Backorder"
    else
      json.status "Work in Process"
    end
  else
    json.reference ""
    json.reference_date ""
    json.days_order_process ""
    if sales_order.FULFILLQTY > 0
      json.status "Fulfillable"
    elsif sales_order.BACKORDQTY > 0
      json.status "Backorder"
    end
  end
  json.sales_rank sales_order.abc_sales_rank
  json.item sales_order.ITEM #item_link(sales_order.ITEM.strip)
  json.description sales_order.DESC.strip
  json.location sales_order.LOCATION.strip
  json.customer_code sales_order.CUSTOMER.strip
  json.customer_name sales_order.CUSTNAME.strip
  json.customer_group sales_order.CUSTGROUP
  json.sales_rep sales_order.SALESREP
  if sales_order.ORDDATE > 0
    json.order_date to_date_helper(sales_order.ORDDATE)
    json.days_order_open (Time.now.strftime("%Y-%m-%d").to_date - to_date_helper(sales_order.ORDDATE)).to_i
  else
    json.order_date ""
    json.days_order_open ""
  end
  json.qty_ordered sales_order.QTYORDERED.to_f
  json.qty_commit sales_order.QTYCOMMIT.to_f
  json.order_amount sales_order.ORDAMOUNT.to_f
  json.location_stock sales_order.LOCSTOCK.to_f
  json.company_ordered sales_order.OPENORDQTY.to_f
  json.company_stock sales_order.COMPSTOCK.to_f
  json.company_backorder sales_order.BACKORDQTY.to_f
  json.qty_fulfillable sales_order.FULFILLQTY.to_f
end
