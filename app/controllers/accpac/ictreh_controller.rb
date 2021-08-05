class Accpac::IctrehController < ApplicationController
  before_action :set_accpac_ictreh, only: [:show, :details]

  def index
    respond_to do |format|
      format.html
      format.json { render json: Accpac::IctrehDatatable.new(view_context) }
    end
  end

  def show
  end

  def details
    render :partial => 'details'
  end

  private
    def set_accpac_ictreh
      @accpac_ictreh = Accpac::Ictreh.find(params[:id])
    end
end
