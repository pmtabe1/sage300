class Accpac::IcicehController < ApplicationController
  before_action :set_accpac_iciceh, only: [:show, :shipped]

  def index
    respond_to do |format|
      format.html
      format.json { render json: Accpac::IcicehDatatable.new(view_context) }
    end
  end

  def show
  end

  private
    def set_accpac_iciceh
      @accpac_iciceh = Accpac::Iciceh.find(params[:id])
    end
end
