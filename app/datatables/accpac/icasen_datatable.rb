class Accpac::IcasenDatatable
  #include Accpac::IcasenHelper
  include ApplicationHelper

  delegate :params, :link_to, :content_tag, :to_date_helper, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Icasen.count,
      iTotalDisplayRecords: accpac_icasen.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_icasen.map do |value|
      [
        to_date_helper(value.TRANSDATE),
        link_to(value.DOCNUM, value),
        value.ITEMNO,
        value.QUANTITY,
        value.UNIT,
        value.ENTEREDBY
      ]
    end
  end

  def accpac_icasen
    @accpac_icasen ||= fetch_accpac_icasen
  end

  def fetch_accpac_icasen
    accpac_icasen = Accpac::Icasen.order("#{sort_column} #{sort_direction}")
    accpac_icasen = accpac_icasen.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_icasen = accpac_icasen.where("LOWER(DOCNUM) like :search or LOWER(ITEMNO) like :search or LOWER(ENTEREDBY) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_icasen
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[TRANSDATE DOCNUM ITEMNO ENTEREDBY]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
