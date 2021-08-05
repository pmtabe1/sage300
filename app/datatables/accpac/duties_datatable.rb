class Accpac::DutiesDatatable
  include Accpac::IcitemHelper
  delegate :params, :h, :current_user, :link_to, :number_to_currency, :number_with_precision, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Icitem.count,
      iTotalDisplayRecords: items.total_entries,
      aaData: data
    }
  end

  private
  def data
    items.map do |item|
      [
        item.FMTITEMNO,
        item.DESC,
        item.CATEGORY,
        item.COMMODIM,
        item.DUTY,
        hts_duty(item.COMMODIM),
        item.DUTY1,
        item.DUTY2,
        item.DUTY3
      ]
    end
  end

  def items
    @items ||= fetch_items
  end

  def fetch_items
    items = Views::ItemsDuties.order("#{sort_column} #{sort_direction}")
    items = items.page(page).per_page(per_page)
    if params[:sSearch].present?
      items = items.where("LOWER(FMTITEMNO) like :search or LOWER([DESC]) like :search or LOWER(CATEGORY) like :search or LOWER(COMMODIM) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    items
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[FMTITEMNO [DESC] CATEGORY COMMODIM]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
