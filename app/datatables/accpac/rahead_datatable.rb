class Accpac::RaheadDatatable
  delegate :params, :link_to, :accpac_arcu_path, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Rahead.count,
      iTotalDisplayRecords: accpac_rahead.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_rahead.map do |rma|
      [
        link_to(rma.RMANUMBER, rma),
        link_to(rma.CUSTOMER,  accpac_arcu_path(id: rma.CUSTOMER)),
        rma.SHIPNAME,
        rma.RMADATE.to_s.to_date,
        rma.DESC,
        link_to(rma.COMMENT[0,30], "#", title: rma.COMMENT, 'data-placement': 'top', 'data-toggle': 'tooltip')
      ]
    end
  end

  def accpac_rahead
    @accpac_rahead ||= fetch_accpac_rahead
  end

  def fetch_accpac_rahead
    accpac_rahead = Accpac::Rahead.order("#{sort_column} #{sort_direction}")
    accpac_rahead = accpac_rahead.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_rahead = accpac_rahead.where("LOWER(RMANUMBER) like :search or LOWER(CUSTOMER) like :search or LOWER(COMMENT) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_rahead
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[RMANUMBER CUSTOMER SHIPNAME RMADATE [DESC] COMMENT]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
