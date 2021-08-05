class Accpac::IcilocDatatable
  include Accpac::IcilocHelper
  delegate :params, :h, :link_to, :number_to_currency, :accpac_icitem_path,to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Iciloc.count,
      iTotalDisplayRecords: accpac_iciloc.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_iciloc.map do |item|
      [
        link_to(item.ITEMNO, accpac_icitem_path(id: item.ITEMNO)),
        item_desc(item),
        item.LOCATION,
        item.QTYONORDER,
        item.QTYSALORDR,
        item.QTYOFFSET,
        item.COSTOFFSET,
        item.QTYONHAND,
        item.QTYCOMMIT
      ]
    end
  end

  def accpac_iciloc
    @accpac_iciloc ||= fetch_accpac_iciloc
  end

  def fetch_accpac_iciloc
    accpac_iciloc = Accpac::Iciloc.order("#{sort_column} #{sort_direction}")
    accpac_iciloc = accpac_iciloc.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_iciloc = accpac_iciloc.where("LOWER(ITEMNO) like :search or LOWER(LOCATION) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_iciloc
  end


  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[ITEMNO LOCATION QTYONHAND QTYCOMMIT]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
