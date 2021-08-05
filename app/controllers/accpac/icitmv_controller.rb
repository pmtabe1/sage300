class Accpac::IcitmvController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json { render json: Accpac::IcitmvDatatable.new(view_context) }
    end
  end

end
