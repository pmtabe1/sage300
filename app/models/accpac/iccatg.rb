# Sage300 table Item Category.
class Accpac::Iccatg < ActiveRecord::Base
  self.table_name  = 'ICCATG'
  self.primary_key = 'CATEGORY'

  # Association with Items and custom table Budget.
  has_many :icitem, foreign_key: 'CATEGORY'
  has_many :budgets, foreign_key: 'CATEGORY'
end
