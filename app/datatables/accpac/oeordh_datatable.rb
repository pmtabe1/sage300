class Accpac::OeordhDatatable
  include Accpac::OeordhHelper
  delegate :params, :h, :current_user, :to_date_helper, :accpac_arcu_path, :accpac_oeordh_path, :by_sales_rep, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Oeordh.count,
      iTotalDisplayRecords: accpac_oeordh.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_oeordh.map do |order|
      [
        to_date_helper(order.ORDDATE),
        link_to(order.ORDNUMBER, accpac_oeordh_path(id: order.ORDUNIQ.to_i)),
        link_to(order.CUSTOMER, accpac_arcu_path(id: order.CUSTOMER)),
        link_to(order.PONUMBER, accpac_oeordh_path(id: order.ORDUNIQ.to_i)),
        order.oeordh1.ENTEREDBY,
        order.BILNAME,
        order.LOCATION
      ]
    end
  end

  def accpac_oeordh
    @accpac_oeordh ||= fetch_accpac_oeordh
  end

  def fetch_accpac_oeordh
    if current_user.role == "sales_person"
      accpac_oeordh = Accpac::Oeordh.by_sales_rep(current_user).order("#{sort_column} #{sort_direction}")
    elsif current_user.type == "customer"
      if params[:open].present?
        accpac_oeordh = Accpac::Oeordh.open_by_customer(current_user).order("#{sort_column} #{sort_direction}")
      else
        accpac_oeordh = Accpac::Oeordh.by_customer(current_user).order("#{sort_column} #{sort_direction}")
      end
    else
      accpac_oeordh = Accpac::Oeordh.order("#{sort_column} #{sort_direction}")
    end
    accpac_oeordh = accpac_oeordh.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_oeordh = accpac_oeordh.where("LOWER(ORDNUMBER) like :search or LOWER(PONUMBER) like :search or LOWER(CUSTOMER) like :search or LOWER(BILNAME) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_oeordh
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[ORDDATE ORDNUMBER CUSTOMER PONUMBER BILNAME LOCATION VIADESC COMMENT]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
