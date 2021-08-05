# Sage300 Customer's Documents
# Primary key: IDCUST (Customer Number).
class Accpac::Arobl < ActiveRecord::Base
  self.table_name  = 'AROBL'
  self.primary_key = 'IDCUST'
  
  # Assocation with customers.
  belongs_to :arcus, foreign_key: 'IDCUST', class_name: "Arcus"
  belongs_to :arrtb, foreign_key: 'CODETERM'
end
