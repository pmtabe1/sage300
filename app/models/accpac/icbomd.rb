# Sage300 table Bills of Material Components.
class Accpac::Icbomd < ActiveRecord::Base
  self.table_name  = 'ICBOMD'
  self.primary_key = 'ITEMNO'

  belongs_to :icbomh, foreign_key: 'ITEMNO'
end
