class Charts::SalesRepsController < ApplicationController
  def years_sales_chart
    render json: Accpac::Oeshdt.where(YR: years, SALESPER: params[:id]).group(:YR).sum('FAMTSALES-FRETSALES')
  end

  def months_sales_chart
    render json: [
      {name: "#{current_year}", data: Accpac::Oeshdt.where(YR: current_year, PERIOD: months, SALESPER: params[:id]).group(:PERIOD).sum(:FAMTSALES)},
      {name: "#{last_year}", data: Accpac::Oeshdt.where(YR: last_year, PERIOD: months, SALESPER: params[:id]).group(:PERIOD).sum(:QTYSOLD)}
    ]
  end
end
