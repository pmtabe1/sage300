# Sage300 table Customer Item Numbers.
class Accpac::Icitmc < ActiveRecord::Base
  self.table_name  = 'ICITMC'
  self.primary_key = 'ITEMNO'

  # Association with Items and Customers.
  belongs_to :icitem, foreign_key: 'ITEMNO'
  belongs_to :arcus, foreign_key: 'CUSTNO', class_name: "Arcus"
end
