class Accpac::ArcmmController < ApplicationController
  before_action :set_accpac_arcmm, only: [:edit, :update, :destroy]

  def new
    authorize! :create, Accpac::Arcmm
  end

  def edit
    authorize! :update, @accpac_arcmm
  end

  def create
    @accpac_arcus = Accpac::Arcus.find(params[:customer_id])
    @accpac_arcmm = @accpac_arcus.arcmm.create(accpac_arcmm_params)
    respond_to do |format|
      if @accpac_arcmm.save
        format.js

        CustomersCommentsWorker.perform_async(@accpac_arcmm.IDCUST, @accpac_arcmm.TEXTCMNT1, @accpac_arcmm.DATEENTR, @accpac_arcmm.DATEEXPR, @accpac_arcmm.DATEFLUP, @accpac_arcmm.USERID)
      else
        format.html { redirect_back fallback_location: request.referrer, notice: 'Unbale to save comment please try again later.' }
      end
    end
  end

  def update
    respond_to do |format|
      if @accpac_arcmm.update(accpac_arcmm_params)
        format.html { redirect_to accpac_arcmm_url, notice: 'Comment successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize! :destroy, @accpac_arcmm
    @accpac_arcmm.destroy
    respond_to do |format|
      format.js
    end
  end

  private
    def set_accpac_arcmm
      @accpac_arcmm = Accpac::Arcmm.where(IDCUST: params[:customer], AUDTDATE: params[:date], AUDTTIME: params[:time]).first
    end

    def accpac_arcmm_params
      params.require(:arcmm).permit(:IDCUST, :DATEENTR, :CNTUNIQ, :AUDTDATE, :AUDTTIME, :AUDTUSER, :AUDTORG, :DATEEXPR, :DATEFLUP, :TEXTCMNT1, :REVCOM, :CMNTTYPE, :USERID)
    end

end
