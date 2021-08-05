class Accpac::Poinvh1Datatable
  delegate :params, :h, :link_to, :content_tag, :to_date_helper, :accpac_apven_path, :accpac_poporh1_path, :accpac_poinvh1_path, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Poinvh1.count,
      iTotalDisplayRecords: accpac_poinvh1.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_poinvh1.map do |po|
      [
        to_date_helper(po.AUDTDATE),
        link_to(po.INVNUMBER, accpac_poinvh1_path(id: po.INVHSEQ.to_i)),
        link_to(po.PONUMBER, accpac_poporh1_path(id: po.PORHSEQ.to_i)),
        link_to(po.VDCODE, accpac_apven_path(:id => po.VDCODE)),
        po.VDNAME,
      ]
    end
  end

  def accpac_poinvh1
    @accpac_poinvh1 ||= fetch_accpac_poinvh1
  end

  def fetch_accpac_poinvh1
    accpac_poinvh1 = Accpac::Poinvh1.order("#{sort_column} #{sort_direction}")
    accpac_poinvh1 = accpac_poinvh1.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_poinvh1 = accpac_poinvh1.where("LOWER(INVNUMBER) like :search or LOWER(VDCODE) like :search or LOWER(VDNAME) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_poinvh1
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[AUDTDATE INVNUMBER PONUMBER VDCODE VDNAME]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
