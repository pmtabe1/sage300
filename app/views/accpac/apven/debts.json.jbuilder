json.array! @dues.each do |r|
  json.vendor_code r.VENDORID
  json.vendor_name r.VENDNAME
  json.document r.IDINVC
  json.type r.DOCTYPE
  json.group r.IDVENDGRP
  json.invoice_date to_date_helper(r.DATEINVC)
  json.invoice_due_date to_date_helper(r.DATEINVCDU)
  json.date to_date_helper(r.DATEASOF)
  if r.DATELSTACT > 0
      json.last_date_activity to_date_helper(r.DATELSTACT)
  else
      json.last_date_activity ""
  end
  if r.DATELSTSTM > 0
      json.last_statement to_date_helper(r.DATELSTSTM)
  else
      json.last_statement ""
  end
  json.term r.CODETERM
  json.invoice_amount r.AMTINVCHC.to_f
  json.amount_due r.AMTDUEHC.to_f
  json.invoice_amount_over r.INAMTOVER.to_f
  json.percentage_over r.TERMPERTOVER.to_f
  json.days_over r.TERMDAYSOVER
  json.country r.CODECTRY
end
