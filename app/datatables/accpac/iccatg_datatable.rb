class Accpac::IccatgDatatable
  include Accpac::IccatgHelper
  delegate :params, :h, :link_to, :to_date_helper, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Iccatg.count,
      iTotalDisplayRecords: accpac_iccatg.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_iccatg.map do |category|
      [
        link_to(category.CATEGORY, category),
        category.DESC,
        category.AUDTUSER,
        to_date_helper(category.DATELASTMN),
        active(category)
      ]
    end
  end

  def accpac_iccatg
    @accpac_iccatg ||= fetch_accpac_iccatg
  end

  def fetch_accpac_iccatg
    accpac_iccatg = Accpac::Iccatg.order("#{sort_column} #{sort_direction}")
    accpac_iccatg = accpac_iccatg.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_iccatg = accpac_iccatg.where("LOWER(CATEGORY) like :search or LOWER([DESC]) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_iccatg
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[CATEGORY [DESC] AUDTUSER DATELASTMN INACTIVE]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
