class Accpac::IcilocController < ApplicationController
  before_action :set_accpac_iciloc, only: [:show]

  def index
    respond_to do |format|
      format.html
      format.json { render json: Accpac::IcilocDatatable.new(view_context) }
    end
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def update_inventory
    @difference = Views::LocationDiff.all.order(ITEMNO: :asc)
    Accpac::Iciloc.where(ITEMNO: params[:item], LOCATION: params[:location]).update_all(QTYSALORDR: params[:on_order], QTYCOMMIT: params[:committed])
    ahoy.track "Inventory updated", controller: controller_name, action: action_name, url: request.original_url, item: params[:item], location: params[:location]
    respond_to do |format|
      format.js
    end
  end

  private
    def set_accpac_iciloc
      @accpac_iciloc = Accpac::Iciloc.where(ITEMNO: params[:id], LOCATION: params[:loc]).first
    end

end
