class Accpac::Poinvh1Controller < ApplicationController
  before_action :set_accpac_poinvh1, only: [:show, :print, :details]
  before_action :authenticate_user!

  def index
    @accpac_poinvh1 = Accpac::Poinvh1Datatable
    respond_to do |format|
      format.html
      authorize! :index, @accpac_poinvh1,format.json { render json: Accpac::Poinvh1Datatable.new(view_context) }
    end
  end

  def show
    authorize! :read, @accpac_poinvh1
    respond_to do |format|
      format.html
    end
  end

  def details
    render :partial => 'details'
  end

  def print
    respond_to do |format|
      format.html {render layout: 'print'}
    end
  end

  private
    def set_accpac_poinvh1
      @accpac_poinvh1 = Accpac::Poinvh1.find(params[:id])
    end
end
