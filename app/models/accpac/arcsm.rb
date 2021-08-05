# Sage300 Customer Statistics table.
# Primary key: IDCUST (Customer Number).
class Accpac::Arcsm < ActiveRecord::Base
  self.table_name  = 'ARCSM'
  self.primary_key = 'IDCUST'
  
  # Association with customers.
  belongs_to :arcus, foreign_key: 'IDCUST', class_name: "Arcus"
end
