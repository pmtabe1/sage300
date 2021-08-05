class Accpac::IcicehDatatable
  include Accpac::IcicehHelper
  include ApplicationHelper

  delegate :params, :link_to, :content_tag, :to_date_helper, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Iciceh.count,
      iTotalDisplayRecords: accpac_iciceh.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_iciceh.map do |value|
      [
        to_date_helper(value.TRANSDATE),
        link_to(value.DOCNUM, value),
        value.HDRDESC,
        value.ENTEREDBY,
        to_date_helper(value.AUDTDATE),
        iciceh_status(value)
      ]
    end
  end

  def accpac_iciceh
    @accpac_iciceh ||= fetch_accpac_iciceh
  end

  def fetch_accpac_iciceh
    accpac_iciceh = Accpac::Iciceh.order("#{sort_column} #{sort_direction}")
    accpac_iciceh = accpac_iciceh.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_iciceh = accpac_iciceh.where("LOWER(DOCNUM) like :search or LOWER(HDRDESC) like :search or LOWER(ENTEREDBY) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_iciceh
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[TRANSDATE DOCNUM HDRDESC ENTEREDBY AUDTDATE AUDTDATE REFERENCE EMPLOYEENO STATUS]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
