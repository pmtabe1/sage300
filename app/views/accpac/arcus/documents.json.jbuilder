json.array! @documents.each do |document|
  json.document_number document.IDINVC
  json.order_number document.IDORDERNBR
  json.po_number document.IDCUSTPO
  case document.TRXTYPETXT
  when 1
    if to_date_helper(document.DATEDUE) < Time.now.to_date && document.AMTDUEHC > 0
      json.is_over_due "Over Due"
    else
    json.is_over_due ""
    end
  end
  json.due_date to_date_helper(document.DATEDUE)
  case document.TRXTYPETXT
  when 1
    json.document_type "Invoice"
  when 2
    json.document_type "Debit Note"
  when 3
    json.document_type "Credit Note"
  when 4
    json.document_type "Interest"
  when 5
    json.document_type "Unapplied Cash"
  when 10
    json.document_type "Prepayment"
  when 11
    json.document_type "Receipt"
  when 19
    json.document_type "Refund"
  end
  json.document_date to_date_helper(document.DATEINVC)
  json.invoice_amount document.AMTINVCHC.to_f
  if document.SWPAID?
    json.paid "Paid"
  else
    json.paid "Pending"
  end
  json.amount_due document.AMTDUEHC.to_f
  json.year document.FISCYR
  json.period document.FISCPER
end
