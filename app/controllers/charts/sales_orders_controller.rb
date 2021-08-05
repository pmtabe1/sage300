class Charts::SalesOrdersController < ApplicationController
  def daily_backorder_log
    render json: BackorderLog.group_by_day(:created_at).sum(:amount)
  end

  def backorders_territory
    render json: Views::Fulfillment.group(:CUSTGROUP).order('sum_amount DESC').sum(:AMOUNT)
  end

  def ytd_net_sales_geochart
    render json: Accpac::Oeshdt.joins(:arcus).where(YR: current_year).group(:CODECTRY).sum('FAMTSALES - FRETSALES')
  end

  def ytd_net_sales_geochart_states
    render json: Accpac::Oeshdt.joins(:arcus).where(YR: current_year).group(:CODESTTE).sum('FAMTSALES - FRETSALES')
  end

  def order_action
    render json: [
      {name: "Work in Process", data: Views::SalesOrderLog.where(created_at: 280.days.ago..Time.now).group("CAST(created_at AS DATE)").sum(:work_in_process_amount)},
      {name: "Backorders", data: Views::SalesOrderLog.where(created_at: 280.days.ago..Time.now).group("CAST(created_at AS DATE)").sum(:backorder_amount)},
      {name: "Fulfillable", data: Views::SalesOrderLog.where(created_at: 280.days.ago..Time.now).group("CAST(created_at AS DATE)").sum(:fulfillable_amount)},
      {name: "Open Orders", data: Views::SalesOrderLog.where(created_at: 280.days.ago..Time.now).group("CAST(created_at AS DATE)").sum(:open_order_amount)}
    ]
  end

  def outbound_documents
    render json: [
      { name: "Invoices", data: Accpac::Oeinvh.where(INVDATE: 90.days.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d")).group("CONVERT(DATE, CAST(INVDATE AS VARCHAR(8)), 112)").count },
      { name: "Shipments", data: Accpac::Oeshih.where(SHIDATE: 90.days.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d")).group("CONVERT(DATE, CAST(SHIDATE AS VARCHAR(8)), 112)").count },
      { name: "Sales Orders", data: Accpac::Oeordh.where(ORDDATE: 90.days.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d")).group("CONVERT(DATE, CAST(ORDDATE AS VARCHAR(8)), 112)").count }
    ]
  end

  def daily_orders_by_users
    render json: Views::UsersReport.select(:ENTEREDBY).where.not(ENTEREDBY: "").filter(params.slice(:start_date, :end_date, :entered_by)).group(:ENTEREDBY).map { |user|
      { name: user.ENTEREDBY,
        data: Views::UsersReport.where(ENTEREDBY: user.ENTEREDBY).filter(params.slice(
          :start_date,
          :end_date,
          :entered_by
        )).group(:ORDDATE).order(ORDDATE: :asc).sum(:ORDERS)
      }
    }
  end 

  def monthly_orders_by_users
    render json: Views::UsersReport.select(:ENTEREDBY).where.not(ENTEREDBY: "").filter(params.slice(:start_date, :end_date, :entered_by)).group(:ENTEREDBY).map { |user|
      { name: user.ENTEREDBY,
        data: Views::UsersReport.where(ENTEREDBY: user.ENTEREDBY).filter(params.slice(
          :start_date,
          :end_date,
          :entered_by
        )).group(:YEAR, :MONTH).order(YEAR: :asc, MONTH: :asc).sum(:ORDERS)
      }
    }
  end
end
