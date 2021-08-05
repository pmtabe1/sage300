class Accpac::ApvenDatatable
  delegate :params, :h, :link_to, :content_tag, to: :@view
  include ApplicationHelper

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Accpac::Apven.count,
      iTotalDisplayRecords: accpac_apven.total_entries,
      aaData: data
    }
  end

  private
  def data
    accpac_apven.map do |vendor|
      [
        link_to(vendor.VENDORID, vendor),
        link_to(vendor.VENDNAME, vendor),
        vendor.IDGRP,
        if vendor.DATESTART > 0
          to_date_helper(vendor.DATESTART)
        else
          vendor.DATESTART
        end
      ]
    end
  end

  def accpac_apven
    @accpac_apven ||= fetch_accpac_apven
  end

  def fetch_accpac_apven
    accpac_apven = Accpac::Apven.order("#{sort_column} #{sort_direction}")
    accpac_apven = accpac_apven.page(page).per_page(per_page)
    if params[:sSearch].present?
      accpac_apven = accpac_apven.where("LOWER(VENDORID) like :search or LOWER(VENDNAME) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    accpac_apven
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[VENDORID VENDNAME IDGRP DATESTART SWHOLD TEXTSTRE1 CODECTRY]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
