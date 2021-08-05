class Accpac::Porcph1Datatable
  include Accpac::Poporh1Helper
  include ApplicationHelper
  delegate :params, :h, :link_to, :content_tag, :accpac_apven_path, :accpac_poporh1_path, :accpac_porcph1_path, :number_to_currency, :current_user, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: datatable_filtered,
      iTotalDisplayRecords: accpac_porcph1.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_porcph1.map do |receipt|
      [
        to_date_helper(receipt.DATE),
        link_to(receipt.RCPNUMBER, accpac_porcph1_path(id: receipt.RCPHSEQ.to_i)),
        link_to(receipt.PONUMBER, accpac_poporh1_path(id: receipt.PORHSEQ.to_i)),
        link_to(receipt.VDCODE, accpac_apven_path(id: receipt.VDCODE)),
        receipt.VDNAME
      ]
    end
  end

  def accpac_porcph1
    @accpac_porcph1 ||= fetch_accpac_porcph1
  end

  def fetch_accpac_porcph1
    accpac_porcph1 = Accpac::Porcph1.order("#{sort_column} #{sort_direction}")
    accpac_porcph1 = accpac_porcph1.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_porcph1 = accpac_porcph1.where("LOWER(RCPNUMBER) like :search or LOWER(PONUMBER) like :search or LOWER(VDCODE) like :search or LOWER(VDNAME) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_porcph1
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[POSTDATE RCPNUMBER PONUMBER VDCODE VDNAME]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
