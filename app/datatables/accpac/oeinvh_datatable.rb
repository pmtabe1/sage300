class Accpac::OeinvhDatatable
  include Accpac::OeinvhHelper
  delegate :params, :h, :link_to, :current_user, :to_date_helper, :accpac_oeordh_path, :accpac_arcu_path, :accpac_oeinvh_path, :by_sales_rep, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Oeinvh.count,
      iTotalDisplayRecords: accpac_oeinvh.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_oeinvh.map do |invoice|
      [
        to_date_helper(invoice.INVDATE),
        link_to(invoice.INVNUMBER, accpac_oeinvh_path(id: invoice.INVUNIQ.to_i)),
        link_to(invoice.ORDNUMBER, accpac_oeordh_path(id: sales_order_link(invoice.ORDNUMBER))),
        invoice.PONUMBER,
        link_to(invoice.BILNAME, accpac_arcu_path(id: invoice.CUSTOMER))
      ]
    end
  end

  def accpac_oeinvh
    @accpac_oeinvh ||= fetch_accpac_oeinvh
  end

  def fetch_accpac_oeinvh
    if current_user.role == "sales_person"
      accpac_oeinvh = Accpac::Oeinvh.by_sales_rep(current_user).order("#{sort_column} #{sort_direction}")
    elsif current_user.type == "customer"
      if params[:pending].present?
        accpac_oeinvh = Accpac::Oeinvh.joins("INNER JOIN AROBS ON AROBS.IDINVC = OEINVH.INVNUMBER AND AROBS.TXTTRXTYPE = 1 AND AROBS.SWPAID = 0").by_customer(current_user).order("#{sort_column} #{sort_direction}")
      else
        accpac_oeinvh = Accpac::Oeinvh.by_customer(current_user).order("#{sort_column} #{sort_direction}")
      end
    else
      accpac_oeinvh = Accpac::Oeinvh.order("#{sort_column} #{sort_direction}")
    end
    accpac_oeinvh = accpac_oeinvh.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_oeinvh = accpac_oeinvh.where("LOWER(INVNUMBER) like :search or LOWER(ORDNUMBER) like :search or LOWER(PONUMBER) like :search or LOWER(CUSTOMER) like :search or LOWER(BILNAME) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_oeinvh
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[INVDATE INVNUMBER ORDNUMBER PONUMBER CUSTOMER BILNAME LOCATION VIADESC]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
