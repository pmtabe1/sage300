class Charts::SalesAnalysisController < ApplicationController
  def sales_analysis_method
    Views::SalesAnalysisDetails
  end

  def sales_trend
    render json: sales_analysis_method.filter(params.slice(
      :start_date,
      :end_date,
      :item,
      :category,
      :customer,
      :country,
      :sales_person,
      :optfield_category,
      :optfield_product,
      :optfield_type)).group(:YR, :PERIOD).order(YR: :asc, PERIOD: :asc).sum('FAMTSALES - FRETSALES')
  end

  def net_sales_by_years
    render json: sales_analysis_method.filter(params.slice(
      :start_date,
      :end_date,
      :item,
      :category,
      :customer,
      :country,
      :sales_person,
      :optfield_category,
      :optfield_product,
      :optfield_type)).group(:YR).sum('FAMTSALES - FRETSALES')
  end

  def ytd_net_sales
    render json: sales_analysis_method.where('DATEPART(dy, CONVERT(DATE, NULLIF (CONVERT(VARCHAR(10), CONVERT(INT, [TRANDATE])), 0))) <= DATEPART(dy, GETDATE())').filter(params.slice(
      :start_date,
      :end_date,
      :item,
      :category,
      :customer,
      :country,
      :sales_person,
      :optfield_category,
      :optfield_product,
      :optfield_type)).group(:YR).sum('FAMTSALES - FRETSALES')
  end

  def net_sales_by_countries
    render json: sales_analysis_method.filter(params.slice(
      :start_date,
      :end_date,
      :item,
      :category,
      :customer,
      :country,
      :sales_person,
      :optfield_category,
      :optfield_product,
      :optfield_type)).group(:CODECTRY).sum('FAMTSALES - FRETSALES')
  end

  def daily_sales
    actual = Accpac::Oeshdt.where(
      TRANDATE: 30.days.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d"), YR: current_year).group(
        "CONVERT(DATE, CAST(TRANDATE AS VARCHAR(8)), 112)").order(
          "CONVERT(DATE, CAST(TRANDATE AS VARCHAR(8)), 112) ASC").sum("FAMTSALES - FRETSALES")
    previous = Accpac::Oeshdt.where(
      TRANDATE: (30.days.ago-1.year).strftime("%Y%m%d")..(Time.now-1.year).strftime("%Y%m%d"), YR: last_year).group(
        "DATEADD(year, 1, CONVERT(DATE, CAST(TRANDATE AS VARCHAR(8)), 112))").order(
          "DATEADD(year, 1, CONVERT(DATE, CAST(TRANDATE AS VARCHAR(8)), 112))").sum("FAMTSALES - FRETSALES")

    # Sales forecast using Prophet
    series = Accpac::Oeshdt.group("CONVERT(DATE, CAST(TRANDATE AS VARCHAR(8)), 112)").sum("FAMTSALES-FRETSALES")
    data = Prophet.forecast(series, count: 10)
    hash = Hash[data.collect { |k,v| [k.to_date.strftime("%Y-%m-%d"), v.to_i]}]

    render json: [
      {name: "Current Year", data: actual},
      {name: "Last Year", data: previous},
      {name: "Forecast", data: hash}
    ]
  end
end
