# Sage300 customer's Comment Types table.
# Primary key: CMNTTYPE (Comment Type).
class Accpac::Arcmmtp < ActiveRecord::Base
  self.table_name  = 'ARCMMTP'
  self.primary_key = 'CMNTTYPE'

  # Associtaion with customers and customer's comments.
  has_many :arcmm, foreign_key: 'CMNTTYPE'
  has_many :arcus, through: :arcmm, class_name: "Arcus"
end
