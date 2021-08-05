class Charts::ItemsController < ApplicationController
  include Accpac::GlacgrpHelper

  def sales_chart
    render json: Accpac::Oeshdt.where(YR: years, ITEM: params[:id]).group(:YR).sum('FAMTSALES - FRETSALES')
  end

  def sales_trend_geochart
    render json: Accpac::Oeshdt.joins(:arcus).where(TRANDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), ITEM: params[:id]).group(:CODECTRY).sum('FAMTSALES - FRETSALES')
  end

  def order_count_trend
    render json: Accpac::Oeshdt.where(TRANDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), ITEM: params[:id]).group(:YR, :PERIOD).order(YR: :asc).count(:ORDNUMBER)
  end

  def sales_trend
    render json: Accpac::Oeshdt.where(TRANDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), ITEM: params[:id]).group(:YR, :PERIOD).order(YR: :asc).sum(:FAMTSALES)
  end

  def sales_and_purchases_trend
    series = Accpac::Oeshdt.where(ITEM: params[:id]).group("CONVERT(DATE, CAST(TRANDATE AS VARCHAR(8)), 112)").sum(:QTYSOLD)
    f = Prophet.forecast(series, count: 90)
    s = Accpac::Oeshdt.where(TRANDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), ITEM: params[:id]).group("CONVERT(DATE, CAST(TRANDATE AS VARCHAR(8)), 112)").sum(:QTYSOLD)
    p = Accpac::Pohstl.where(TRANSDATE: 36.months.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), ITEMNO: params[:id]).group("CONVERT(DATE, CAST(TRANSDATE AS VARCHAR(8)), 112)").sum(:SQTOTAL)
    sales = Hash[s.group_by { |k,_v| k.to_date.strftime("%Y-%m")}]
    purchases = Hash[p.group_by { |k,_v| k.to_date.strftime("%Y-%m")}]
    forecast = Hash[f.group_by { |k,_v| k.to_date.strftime("%Y-%m")}]

    render json: [
      {name: "Sales", data: sales.transform_values {|a| a.sum(&:last)}},
      {name: "Purchases", data: purchases.transform_values {|a| a.sum(&:last)}},
      {name: "Sales Forecast", data: forecast.transform_values {|a| a.sum(&:last)}}
    ]
  end

  def item_valuation
    render json: Accpac::Icival.where(FISCYEAR: current_year).group(:FISCYEAR, :FISCPERIOD).sum(:TOTALCOST)
  end

  def sales_prediction
    series = Accpac::Oeshdt.group("CONVERT(DATE, CAST(TRANDATE AS VARCHAR(8)), 112)").sum('FAMTSALES - FRETSALES')
    data = Prophet.forecast(series, count: 90)
    hash = Hash[data.group_by { |k,_v| k.to_date.strftime("%Y-%m")}]

    render json: hash.transform_values {|a| a.sum(&:last) }
  end
end
