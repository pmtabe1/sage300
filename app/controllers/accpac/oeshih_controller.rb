class Accpac::OeshihController < ApplicationController
  before_action :set_accpac_oeshih, only: [:show, :details]
  before_action :authenticate_user!

  def index
    @accpac_oeshih = Accpac::OeshihDatatable
    respond_to do |format|
      format.html
      authorize! :index, @accpac_oeshih, format.json { render json: Accpac::OeshihDatatable.new(view_context) }
    end
  end

  def show
    authorize! :read, @accpac_oeshih
  end

  def details
    authorize! :read, @accpac_oeshih
    render :partial => 'details'
  end

  private
    def set_accpac_oeshih
      @accpac_oeshih = Accpac::Oeshih.find(params[:id])
    end
end
