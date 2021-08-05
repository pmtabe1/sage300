json.array! @documents.each do |document|
  json.document_number document.IDINVC
  json.order_number document.IDORDERNBR
  json.po_number document.IDPONBR
  json.due_date to_date_helper(document.DATEINVCDU)
  case document.TXTTRXTYPE
  when 1
    json.document_type "Invoice"
  when 2
    json.document_type "Debit Note"
  when 3
    json.document_type "Credit Note"
  when 4
    json.document_type "Interest"
  when 10
    json.document_type "Prepayment"
  when 11
    json.document_type "Payment"
  end
  json.document_date to_date_helper(document.DATEINVC)
  json.invoice_amount document.AMTINVCTC.to_f
  if document.SWPAID?
    json.paid "Paid"
  else
    json.paid "Pending"
  end
  json.amount_due document.AMTDUETC.to_f
  json.year document.FISCYR
  json.period document.FISCPER
end
