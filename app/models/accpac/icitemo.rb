# Sage300 table Item Optional Fields.
class Accpac::Icitemo < ActiveRecord::Base
  self.table_name  = 'ICITEMO'
  self.primary_key = 'ITEMNO'

  # Association with Items.
  belongs_to :icitem, foreign_key: 'ITEMNO'
  
  # Scope to filter only duties Optional Fields.
  scope :duties, ->{ where("OPTFIELD LIKE ?", 'DUTY%') }
end
