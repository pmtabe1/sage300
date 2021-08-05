class Accpac::IctrehDatatable
  delegate :params, :link_to, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Ictreh.count,
      iTotalDisplayRecords: accpac_ictreh.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_ictreh.map do |value|
      [
        link_to(value.TRANFENSEQ, value),
        link_to(value.DOCNUM, value),
        value.AUDTUSER,
        value.TRANSDATE.to_s.to_date,
        value.FROMNUM
      ]
    end
  end

  def accpac_ictreh
    @accpac_ictreh ||= fetch_accpac_ictreh
  end

  def fetch_accpac_ictreh
    accpac_ictreh = Accpac::Ictreh.order("#{sort_column} #{sort_direction}")
    accpac_ictreh = accpac_ictreh.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_ictreh = accpac_ictreh.where("LOWER(DOCNUM) like :search or LOWER(HDRDESC) like :search or LOWER(REFERENCE) like :search or LOWER(FROMNUM) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_ictreh
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[TRANFENSEQ DOCNUM AUDTUSER TRANSDATE FROMNUM]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
