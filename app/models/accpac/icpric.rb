# Sage300 table Item Pricing.
class Accpac::Icpric < ActiveRecord::Base
  self.table_name  = 'ICPRIC'
  self.primary_key = 'PRICELIST'

  # Association with Items, Price List Codes, Customers and Item Pricing Details.
  has_many :icpricp, foreign_key: 'PRICELIST'
  belongs_to :icpcod, foreign_key: 'PRICELIST'
  belongs_to :icitem, foreign_key: 'ITEMNO'
  belongs_to :arcus, foreign_key: 'PRICELIST', class_name: "Arcus"
end
