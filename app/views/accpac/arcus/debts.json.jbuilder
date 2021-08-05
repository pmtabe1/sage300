json.array! @customer_dues.each do |customer|
    json.customer_code customer.IDCUST
    json.customer_name customer.NAMECUST
    json.invoice customer.IDINVC
    json.sales_order customer.IDORDERNBR
    json.document_type customer.DOCTYPE
    json.group customer.IDGRP
    json.invoice_date to_date_helper(customer.DATEINVC)
    json.due_date to_date_helper(customer.DATEDUE)
    json.date to_date_helper(customer.DATEASOF)
    if customer.DATELSTACT > 0
        json.last_date_activity to_date_helper(customer.DATELSTACT)
    else
        json.last_date_activity ""
    end
    if customer.DATELSTSTM > 0
        json.last_statement to_date_helper(customer.DATELSTSTM)
    else
        json.last_statement ""
    end
    json.term customer.CODETERM
    json.currency customer.CODECURN
    json.invoice_amount customer.AMTINVCHC.to_f
    json.amount_due customer.AMTDUEHC.to_f
    json.invoice_amount_over customer.INAMTOVER.to_f
    #TERMPERTOVER
    #TERMDAYSOVER
    json.sales_rep customer.CODESLSP1
    json.shipment customer.IDSHIPNBR
    json.territory customer.CODETERR
    json.country customer.CODECTRY
end
