# Sage300 Salespersons table.
# Primary key: CODESLP.
class Accpac::Arsap < ActiveRecord::Base
  self.table_name  = 'ARSAP'
  self.primary_key = 'CODESLSP'

  # Assocation with customers, sales history and custom 
  # fulfillable model.
  has_many :arcus, foreign_key: 'CODESLSP1', class_name: "Arcus"
  has_many :oeshdt, foreign_key: 'SALESPER'
  has_many :fulfillment, foreign_key: 'SALESREP'
end
