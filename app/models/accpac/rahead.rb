# Sage300 table Return Authorizations.
class Accpac::Rahead < ActiveRecord::Base
  self.table_name  = 'RAHEAD'
  self.primary_key = 'RMAUNIQ'
  
  # Association with Return Authorization Details and Customers.
  has_many :radet, foreign_key: 'RMAUNIQ'
  belongs_to :arcus, foreign_key: 'CUSTOMER'
end
