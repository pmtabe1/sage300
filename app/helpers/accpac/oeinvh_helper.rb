module Accpac::OeinvhHelper

  # invoice status index view
  def invoice_status
    Accpac::Arobs.select('IDINVC, sum(AMTDUETC) as ORAMOUNT, sum(AMTPYMRMTC) as REMAMMOUNT').group(:IDINVC)
  end

  def sales_order_link(order)
    Accpac::Oeordh.find_by(ORDNUMBER: order).ORDUNIQ.to_i
  end

  def pending_invoices?
    if params[:pending].present?
      accpac_oeinvh_index_url(pending: "true", format: "json")
    else
      accpac_oeinvh_index_url(format: "json")
    end
  end

  def invoice_location_detail
    if current_user.location.present?
      @accpac_oeinvh.oeinvd.where(LOCATION: current_user.location)
    else
      @accpac_oeinvh.oeinvd
    end
  end

  def invoice_location_total
    @accpac_oeinvh.oeinvd.where(LOCATION: current_user.location).sum("OEINVD.UNITPRICE * OEINVD.QTYSHIPPED")
  end
end
