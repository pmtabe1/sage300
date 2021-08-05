class Accpac::IcitemDatatable
  include Accpac::IcitemHelper
  delegate :params, :h, :current_user, :link_to, :number_to_currency, :number_with_precision, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Icitem.count,
      iTotalDisplayRecords: accpac_icitem.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_icitem.map do |item|
      [
        link_to(item.FMTITEMNO, item),
        link_to(item.DESC, item),
        item.STOCKUNIT,
        if current_user.type == "customer"
          item.CATEGORY
        else
          number_with_precision(available(item), precision: 0, delimiter: ',')
        end
      ]
    end
  end

  def accpac_icitem
    @accpac_icitem ||= fetch_accpac_icitem
  end

  def fetch_accpac_icitem
    accpac_icitem = Accpac::Icitem.order("#{sort_column} #{sort_direction}")
    accpac_icitem = accpac_icitem.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_icitem = accpac_icitem.where("LOWER(ITEMNO) like :search or LOWER(FMTITEMNO) like :search or LOWER([DESC]) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_icitem
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[FMTITEMNO [DESC] CATEGORY]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
