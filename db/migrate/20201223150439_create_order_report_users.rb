class CreateOrderReportUsers < ActiveRecord::Migration[5.1]
  def change
    create_view :order_report_users
  end
end
