# Sage300 Customers table.
# Primary key: IDCUST (Customer Number).
class Accpac::Arcus < ActiveRecord::Base
  self.table_name  = 'ARCUS'
  self.primary_key = 'IDCUST'

  # Assocation with all tables where customer is present 
  # and where it is usefull for later calls with ActiveRecord.
  # - Sales History
  # - Sales Oorder headers
  # - Customer Documents
  # - Custom order action view
  # - Budget
  # - Claims... etc.
  has_many :oeshdt, foreign_key: 'CUSTOMER'
  has_many :oeordh, foreign_key: 'CUSTOMER'
  has_many :rahead, foreign_key: 'CUSTOMER'
  has_many :arobl, foreign_key: 'IDCUST'
  has_many :arcsm, foreign_key: 'IDCUST'
  belongs_to :arsap, foreign_key: 'CODESLSP'
  has_many :icpric, foreign_key: 'PRICELIST'
  has_many :icpricp, foreign_key: 'PRICELIST'
  has_many :budget, foreign_key: 'IDCUST'
  has_many :claims, foreign_key: 'IDCUST'
  has_many :arcmm, foreign_key: 'IDCUST', class_name: "Accpac::Arcmm"

  # Scenic views assocation.
  has_many :unpaid_receivable, foreign_key: 'IDCUST', class_name: "Views::UnpaidReceivable"
  has_many :order_action, foreign_key: 'CUSTOMER', class_name: "Views::OrderAction"
  has_one :customers_ranking, foreign_key: 'CUSTOMER', class_name: "Views::CustomersRanking"

  scope :by_sales_rep, lambda { |user| where("CODESLSP1 = ? OR CODESLSP2 = ? OR CODESLSP3 = ? OR CODESLSP4 = ?", user, user, user, user) }
  scope :sales_budget, lambda { |user| where(CODESLSP1: user, SWACTV: 1).order(IDCUST: :asc) }

  # This are the sales person association columns in Sage300 
  # every customer can have more upto 5 sales person
  SALESPERSON = ["CODESLSP1", "CODESLSP2", "CODESLSP3", "CODESLSP4", "CODESLSP5"]

  # Customer address rendered as html.
  def address
    "#{self.TEXTSTRE1} #{self.TEXTSTRE2}<br> #{self.NAMECITY}, #{self.CODESTTE} #{self.CODEPSTL}<br> <abbr title='Phone'>P:</abbr> #{helper.number_to_phone(self.TEXTPHON1)}".html_safe
  end

  # This method include helper standard rails number helper.
  # It is used on address method for phone number.
  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

  # Searchkick for Smart Search Using Elasticsearch.
  searchkick index_name: "customers", callbacks: :async

  def search_data
    {
      customer_id: Accpac::Arcus.find(id).IDCUST,
      customer_name: Accpac::Arcus.find(id).NAMECUST,
      country: Accpac::Arcus.find(id).CODECTRY,
      group: Accpac::Arcus.find(id).IDGRP
    }
  end
end
