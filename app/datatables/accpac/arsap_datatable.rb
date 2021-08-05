class Accpac::ArsapDatatable
  include Accpac::ArsapHelper
  include ApplicationHelper
  delegate :params, :h, :link_to, :number_to_human, :number_to_currency, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Arsap.count,
      iTotalDisplayRecords: accpac_arsap.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_arsap.map do |sales_rep|
      [
        link_to(sales_rep.CODESLSP, sales_rep),
        sales_rep.NAMEEMPL,
        if sales_rep.arcus.count > 0
          sales_rep.arcus.count
        end,
        if sales_rep.SWACTV == 0
          "Inactive"
        else
          "Active"
        end,
        if sales_rep.SWACTV == 0
          to_date_helper(sales_rep.DATEINAC)
        end,
        if sales_rep.SWACTV == 1
          avit_deficit(sales_rep)
        end
      ]
    end
  end

  def accpac_arsap
    @accpac_arsap ||= fetch_accpac_arsap
  end

  def fetch_accpac_arsap
    accpac_arsap = Accpac::Arsap.order("#{sort_column} #{sort_direction}")
    accpac_arsap = accpac_arsap.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_arsap = accpac_arsap.where("LOWER(CODESLSP) like :search or LOWER(NAMEEMPL) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_arsap
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[CODESLSP NAMEEMPL sales_rep.accpac_arcus SWACTV DATEINAC avit_deficit]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
