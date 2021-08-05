json.array! @customers do |customer|
  json.id customer.IDCUST
  json.name customer.NAMECUST
  json.group customer.IDGRP
  json.territory customer.CODETERR
  if customer.DATESTART > 0
    json.created_at to_date_helper(customer.DATESTART)
  else
    json.created_at ""
  end
  json.country customer.CODECTRY
  json.term customer.CODETERM
  json.balance_due customer.AMTBALDUEH
  json.overdue customer.OVERAMT
  json.sales customer_avit_deficit(customer)
end
