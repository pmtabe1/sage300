class Charts::VendorsController < ApplicationController
  def purchases_chart
    render json: Accpac::Pohsth.where(VENDOR: params[:id], FISCYEAR: years).group(:FISCYEAR).sum('FCINVTOTAL + FCCRNTOTAL')
  end

  def purchases_count_trend
    render json: Accpac::Pohstl.where(TRANSDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), VENDOR: params[:id]).group(:FISCYEAR, :FISCPERIOD).order(FISCYEAR: :asc).count(:DOCNUMBER)
  end

  def purchases_trend
    render json: Accpac::Pohsth.where(AUDTDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), VENDOR: params[:id]).group(:FISCYEAR, :FISCPERIOD).order(FISCYEAR: :asc).sum('FCINVTOTAL + FCCRNTOTAL')
  end

  def invoices_trend
    render json: Accpac::Apobl.where(DATEBTCH: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), IDVEND: params[:id], TXTTRXTYPE: 1).group(:FISCYR, :FISCPER).order(FISCYR: :asc).sum(:AMTINVCTC)
  end

  def payments_chart
    render json: Accpac::Apobl.where(IDVEND: params[:id], FISCYR: years, TXTTRXTYPE: 10..11).group(:FISCYR).sum("ABS(AMTINVCTC)")
  end
end
