# Sage300 table Orders.
class Accpac::Oeordh < ActiveRecord::Base
  self.table_name  = 'OEORDH'
  self.primary_key = 'ORDUNIQ'

  # Association with Order Details, Customers and Locations.
  has_many :oeordd, foreign_key: 'ORDUNIQ'
  has_one :oeordh1, foreign_key: 'ORDUNIQ'
  belongs_to :arcus, foreign_key: 'CUSTOMER', class_name: "Arcus"
  belongs_to :icloc, foreign_key: 'LOCATION'

  # Scopes to filters orders by completed, custoemr, sales persons, etc.
  scope :open, ->{ where("COMPLETE < ?", 3) }
  scope :open_by_customer, lambda { |user| where("COMPLETE < ? AND CUSTOMER = ?", 3, user.customer_id) }
  scope :by_customer, lambda { |user| where(CUSTOMER: user.customer_id) }
  scope :by_sales_rep, lambda { |user| joins(:arcus).where("CODESLSP1 = ? OR CODESLSP2 = ? OR CODESLSP3 = ? OR CODESLSP4 = ?", user.arsap, user.arsap, user.arsap, user.arsap) }

  # This are the sales person association columns in Accpac
  # every customer can have more upto 5 sales person
  SALESPERSON = ["SALESPER1", "SALESPER2", "SALESPER3", "SALESPER4", "SALESPER5"]

  # Shipto address rendered as html.
  def address
    "#{self.SHPADDR1} #{self.SHPADDR2}<br> #{self.SHPCITY}, #{self.SHPSTATE}, #{self.SHPZIP} #{self.SHPCOUNTRY}<br>".html_safe
  end
end
