json.array! @order_action.each do |sales_order|
  #json.order_number order_link(sales_order.ORDUNIQ, sales_order.ORDNUMBER.strip)
  json.order_number sales_order.ORDNUMBER
  json.last_invoice sales_order.LASTINVNUM
  if sales_order.REFERENCE.present?
    #json.reference reference_link(sales_order.REFID, sales_order.REFERENCE)
    json.reference sales_order.REFERENCE
    if sales_order.REFDATE.present?
      json.reference_date sales_order.REFDATE.to_date
      json.days_order_process (Time.now.strftime("%Y-%m-%d").to_date - sales_order.REFDATE.to_date).to_i
    else
      json.reference_date ""
      json.days_order_process ""
    end
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
  #json.item item_link(sales_order.ITEM.strip)
  json.item sales_order.ITEM
  json.description sales_order.DESC.strip
  json.location sales_order.LOCATION.strip
  json.customer_code sales_order.CUSTOMER.strip
  json.customer_name sales_order.CUSTNAME.strip
  json.country sales_order.CODECTRY
  json.customer_group sales_order.CUSTGROUP
  json.sales_rep sales_order.SALESREP
  json.entered_by sales_order.ENTEREDBY
  json.soreference sales_order.SOREFERENCE
  json.ponumber sales_order.PONUMBER
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
  json.gross_margin (((sales_order.ORDAMOUNT - sales_order.MRCAMOUNT)/sales_order.ORDAMOUNT)*100).to_f
  json.location_stock sales_order.LOCSTOCK.to_f
  json.company_ordered sales_order.OPENORDQTY.to_f
  json.company_stock sales_order.COMPSTOCK.to_f
  json.company_backorder sales_order.BACKORDQTY.to_f
  json.qty_fulfillable sales_order.FULFILLQTY.to_f
end
