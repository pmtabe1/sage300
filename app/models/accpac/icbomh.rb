# Sage300 table Bills of Material.
class Accpac::Icbomh < ActiveRecord::Base
  self.table_name  = 'ICBOMH'
  self.primary_key = 'ITEMNO'

  has_many :icbomd, foreign_key: 'ITEMNO'
  has_many :icitem, foreign_key: 'ITEMNO'
end
