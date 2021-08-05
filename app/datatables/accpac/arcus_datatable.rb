class Accpac::ArcusDatatable
  include Accpac::ArcusHelper
  include ApplicationHelper
  delegate :params, :h, :link_to, :number_to_currency, :number_to_human, :content_tag, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Arcus.count,
      iTotalDisplayRecords: accpac_arcus.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_arcus.map do |customer|
      [
        link_to(customer.IDCUST, customer),
        link_to(customer.NAMECUST, customer),
        customer.IDGRP,
        customer.SWHOLD,
        customer.CODECTRY,
        customer_avit_deficit(customer)
      ]
    end
  end

  def accpac_arcus
    @accpac_arcus ||= fetch_accpac_arcus
  end

  def fetch_accpac_arcus
    accpac_arcus = Accpac::Arcus.order("#{sort_column} #{sort_direction}")
    accpac_arcus = accpac_arcus.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_arcus = accpac_arcus.where("LOWER(IDCUST) like :search or LOWER(NAMECUST) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_arcus
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[IDCUST NAMECUST IDGRP DATESTART SWHOLD TEXTSTRE1 CODECTRY]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
