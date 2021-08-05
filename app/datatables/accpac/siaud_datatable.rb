class Accpac::SiaudDatatable
  include Accpac::SiaudHelper
  delegate :params, :h, :link_to, :accpac_icitem_path, :to_date_helper, :delete, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Siaud.count,
      iTotalDisplayRecords: accpac_siaud.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_siaud.map do |change|
      [
        to_date_helper(change.SIDATE),
        change.OLDITEMNO,
        change.OLDFORMATT,
        link_to(change.NEWFORMATT, accpac_icitem_path(:id => change.NEWFORMATT)),
        link_to(change.NEWITEMDES, accpac_icitem_path(:id => change.NEWFORMATT)),
        link_to(change.ACTION, "#", title: type_action(change), 'data-placement': 'top', 'data-toggle': :tooltip)
      ]
    end
  end

  def accpac_siaud
    @accpac_siaud ||= fetch_accpac_siaud
  end

  def fetch_accpac_siaud
    accpac_siaud = Accpac::Siaud.all.order("#{sort_column} #{sort_direction}")
    accpac_siaud = accpac_siaud.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_siaud = accpac_siaud.where("LOWER(OLDITEMNO) like :search or LOWER(OLDFORMATT) like :search or LOWER(NEWFORMATT) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_siaud = accpac_siaud
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[SIDATE OLDITEMNO OLDFORMATT NEWFORMATT NEWITEMDES ACTION]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "asc" : "desc"
  end
end
