class Accpac::SiaudController < ApplicationController
  before_action :authenticate_user!

  def index
    @accpac_siaud = Accpac::SiaudDatatable
    respond_to do |format|
      format.html
      authorize! :index, @accpac_siaud, format.json { render json: Accpac::SiaudDatatable.new(view_context) }
    end
  end

end
