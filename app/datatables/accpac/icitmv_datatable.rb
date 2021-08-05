class Accpac::IcitmvDatatable
  include Accpac::IcitmvHelper
  delegate :params, :h, :link_to, :current_user, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: datatable_filtered,
      iTotalDisplayRecords: accpac_icitmv.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_icitmv.map do |item|
      [
        item_formatted(item),
        item.VENDITEM,
        item_description(item),
        item.VENDCNCY,
        item.COSTUNIT,
        number_to_currency(item.VENDCOST, precision: 6)
      ]
    end
  end

  def accpac_icitmv
    @accpac_icitmv ||= fetch_accpac_icitmv
  end

  def fetch_accpac_icitmv
    if current_user.type == "vendor"
      accpac_icitmv = Accpac::Icitmv.by_vendor(current_user).order("#{sort_column} #{sort_direction}")
    elsif params[:item_vendor].present?
      accpac_icitmv = Accpac::Icitmv.where(VENDNUM: params[:item_vendor]).order("#{sort_column} #{sort_direction}")
    else
      accpac_icitmv = Accpac::Icitmv.order("#{sort_column} #{sort_direction}")
    end
    accpac_icitmv = accpac_icitmv.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_icitmv = accpac_icitmv.where("LOWER(ITEMNO) like :search or LOWER(VENDITEM) like :search or LOWER(VENDNAME) like :search or LOWER(VENDNUM) like :search", search: "%#{params[:sSearch].gsub('-', '').downcase}%")
    end
    accpac_icitmv
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[ITEMNO VENDITEM VENDNUM VENDCNCY COSTUNIT VENDCOST]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
