json.array! @backorders.each do |sales_order|
  json.order_number sales_order.ORDNUMBER #order_link(sales_order.ORDUNIQ, sales_order.ORDNUMBER.strip)
  json.sales_rank sales_order.abc_sales_rank
  json.item sales_order.ITEM #item_link(sales_order.ITEM.strip)
  json.description sales_order.DESC.strip
  # START Optional Fields & Category #
  json.category_description sales_order.CATDESC
  json.of_category sales_order.OPTFCAT
  json.of_type sales_order.OPTFTYPE
  # END Optional Fields & Category #
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
