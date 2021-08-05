class Accpac::RaheadController < ApplicationController
  before_action :set_accpac_rahead, only: [:show]
  before_action :authenticate_user!

  def index
    @accpac_rahead = Accpac::RaheadDatatable
    respond_to do |format|
      format.html
      authorize! :index, @accpac_rahead, format.json { render json: Accpac::RaheadDatatable.new(view_context) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.csv
      format.xls
    end
  end

  private
    def set_accpac_rahead
      @accpac_rahead = Accpac::Rahead.find(params[:id])
    end
end
