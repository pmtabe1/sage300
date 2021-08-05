class Charts::CustomersController < ApplicationController
  def sales_chart
    render json: Accpac::Oeshdt.where(YR: years, CUSTOMER: params[:id]).group(:YR).sum('FAMTSALES - FRETSALES')
  end

  def order_count_trend
    render json: Accpac::Oeshdt.where(TRANDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), CUSTOMER: params[:id]).group(:YR, :PERIOD).order(YR: :asc, PERIOD: :asc).count(:ORDNUMBER)
  end

  def sales_trend
    render json: Accpac::Oeshdt.where(TRANDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), CUSTOMER: params[:id]).group(:YR, :PERIOD).order(YR: :asc, PERIOD: :asc).sum(:FAMTSALES)
  end

  def sales_forecast
    series = Accpac::Oeshdt.where(CUSTOMER: params[:id]).group("CONVERT(DATE, CAST(TRANDATE AS VARCHAR(8)), 112)").sum("FAMTSALES-FRETSALES")
    data = Prophet.forecast(series, count: 90)
    hash = Hash[data.group_by { |k,_v| k.to_date.strftime("%Y-%m")}]

    render json: hash.transform_values {|a| a.sum(&:last)}
  end

  def dues_geochart
    render json: Accpac::Arcus.where('AMTBALDUET > 0').group(:CODECTRY).sum('AMTBALDUET')
  end

  def average_days_to_pay
    render json: Accpac::Arcsm.where(AUDTDATE: 24.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), IDCUST: params[:id]).group(:CNTYR, :CNTPERD).order(CNTYR: :asc, CNTPERD: :asc).sum(:AVGDAYSPAY)
  end
end
