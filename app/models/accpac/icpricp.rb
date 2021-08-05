# Sage300 table 	Item Pricing Details.
class Accpac::Icpricp < ActiveRecord::Base
  self.table_name  = 'ICPRICP'
  self.primary_key = 'PRICELIST'

  # Association with Items, Customers and Price List Codes.
  belongs_to :icpcod, foreign_key: 'PRICELIST'
  belongs_to :icitem, foreign_key: 'ITEMNO'
  belongs_to :arcus, foreign_key: 'PRICLIST', class_name: "Arcus"
end
