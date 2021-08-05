class Accpac::OeshihDatatable
  include Accpac::OeinvhHelper
  delegate :params, :h, :link_to, :current_user, :to_date_helper, :accpac_oeordh_path, :accpac_oeshih_path, :accpac_arcu_path, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Oeshih.count,
      iTotalDisplayRecords: accpac_oeshih.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_oeshih.map do |shipment|
      [
        to_date_helper(shipment.SHIDATE),
        link_to(shipment.SHINUMBER, accpac_oeshih_path(id: shipment.SHIUNIQ.to_i)),
        link_to(shipment.ORDNUMBER, accpac_oeordh_path(id: sales_order_link(shipment.ORDNUMBER))),
        link_to(shipment.BILNAME, accpac_arcu_path(id: shipment.CUSTOMER))
      ]
    end
  end

  def accpac_oeshih
    @accpac_oeshih ||= fetch_accpac_oeshih
  end

  def fetch_accpac_oeshih
    if current_user.role == "sales_person"
      accpac_oeshih = Accpac::Oeshih.joins(:arcus).where("ARCUS.CODESLSP1 = ? ", current_user.arsap).order("#{sort_column} #{sort_direction}")
    else
      accpac_oeshih = Accpac::Oeshih.order("#{sort_column} #{sort_direction}")
    end
    accpac_oeshih = accpac_oeshih.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_oeshih = accpac_oeshih.where("LOWER(SHINUMBER) like :search or LOWER(ORDNUMBER) like :search or LOWER(CUSTOMER) like :search or LOWER(BILNAME) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_oeshih
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[SHIDATE SHINUMBER ORDNUMBER BILNAME]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
