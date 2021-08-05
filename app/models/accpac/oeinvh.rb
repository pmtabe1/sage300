# Sage300 table Invoices.
class Accpac::Oeinvh < ActiveRecord::Base
  #Reusable filter solution module that can be include it into any model that supports filtering.
  include Filterable

  self.table_name  = 'OEINVH'
  self.primary_key = 'INVUNIQ'

  # Association with Invoice Details, Customers and Locations.
  has_many :oeinvd, foreign_key: 'INVUNIQ'
  belongs_to :arcus, foreign_key: 'CUSTOMER', class_name: "Arcus"
  belongs_to :icloc, foreign_key: 'LOCATION'

  # Scopes to filters by Customers and Sales Persons.
  scope :by_customer, lambda { |user| where(CUSTOMER: user.customer_id) }
  scope :by_sales_rep, lambda { |user| joins(:arcus).where("CODESLSP1 = ? OR CODESLSP2 = ? OR CODESLSP3 = ? OR CODESLSP4 = ?", user.arsap, user.arsap, user.arsap, user.arsap) }

  # Scope uses with Filterable module to filter invoices.
  scope :loc, -> (loc) { joins(:oeinvd).where("OEINVD.LOCATION = ?", loc) }
  scope :start_date, -> (start_date) { where("INVDATE >= ?", start_date.to_date.strftime("%Y%m%d")) }
  scope :end_date, -> (end_date) { where("INVDATE <= ?", end_date.to_date.strftime("%Y%m%d")) }

  # This are the sales person association columns in Accpac
  # every customer can have more upto 5 sales person
  SALESPERSON = ["SALESPER1", "SALESPER2", "SALESPER3", "SALESPER4", "SALESPER5"]
end
