# Sage300 table Purchase History.
class Accpac::Pohsth < ActiveRecord::Base
  self.table_name  = 'POHSTH'
  self.primary_key = 'VENDOR'
end
