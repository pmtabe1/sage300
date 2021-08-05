class Accpac::GlamfController < ApplicationController
  before_action :set_accpac_glamf, only: [:show]

  def index
  end

  def show
    authorize! :read, @accpac_glamf
    respond_to do |format|
      format.js
    end
  end

  private
    def set_accpac_glamf
      @accpac_glamf = Accpac::Glamf.where(ACCTGRPCOD: params[:id])
    end
end
