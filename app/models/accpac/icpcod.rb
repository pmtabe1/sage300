# Sage300 table Price List Codes.
class Accpac::Icpcod < ActiveRecord::Base
  self.table_name  = 'ICPCOD'
  self.primary_key = 'PRICELIST'

  # Association with Price Lists and Items.
  belongs_to :arcus, foreign_key: 'PRICLIST', class_name: "Arcus"
  has_many :icpric, foreign_key: 'PRICELIST'
end
