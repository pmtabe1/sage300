class Accpac::Poporh1Datatable
  include Accpac::Poporh1Helper
  delegate :params, :h, :link_to, :content_tag, :to_date_helper, :accpac_apven_path, :accpac_poporh1_path, :number_to_currency, :current_user, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: datatable_filtered,
      iTotalDisplayRecords: accpac_poporh1.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_poporh1.map do |po|
      [
        to_date_helper(po.POSTDATE),
        link_to(po.PONUMBER, accpac_poporh1_path(id: po.PORHSEQ.to_i)),
        link_to(po.VDCODE, accpac_apven_path(:id => po.VDCODE)),
        po.VDNAME,
        is_complete(po)
      ]
    end
  end

  def accpac_poporh1
    @accpac_poporh1 ||= fetch_accpac_poporh1
  end

  def fetch_accpac_poporh1
    if current_user.type == "vendor"
      if params[:open].present?
        accpac_poporh1 = Accpac::Poporh1.open_by_vendor(current_user).order("#{sort_column} #{sort_direction}")
      else
        accpac_poporh1 = Accpac::Poporh1.by_vendor(current_user).order("#{sort_column} #{sort_direction}")
      end
    else
      accpac_poporh1 = Accpac::Poporh1.order("#{sort_column} #{sort_direction}")
    end
    accpac_poporh1 = accpac_poporh1.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_poporh1 = accpac_poporh1.where("LOWER(PONUMBER) like :search or LOWER(VDCODE) like :search or LOWER(VDNAME) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_poporh1
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[POSTDATE PONUMBER VDCODE VDNAME LINES FOBPOINT ISCOMPLETE]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
