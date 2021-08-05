class Accpac::IcicedController < ApplicationController
  before_action :set_accpac_iciced, only: [:update]

  def update
    respond_to do |format|
      if @accpac_iciced.update(accpac_iciced_params)
        format.json { render json: @accpac_iciced.to_json }
      else
        format.json { render json: @accpac_iciced.to_json }
      end
    end
  end

  private
    def set_accpac_iciced
      @accpac_iciced = Accpac::Iciced.find(params[:id])
    end

    def accpac_iciced_params
      params.require(:accpac_iciced).permit(:QUANTITY)
    end
end
