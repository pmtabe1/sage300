# Sage300 table Transaction History.
class Accpac::Ichist < ActiveRecord::Base
  self.table_name  = 'ICHIST'
  self.primary_key = 'ITEMNO'

  belongs_to :icitem, foreign_key: 'ITEMNO'
end
