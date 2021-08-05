# Sage300 Currency Codes table.
# Primary key: CURID (Currency Code).
#
# We use this model for products prices, where it can set 
# with difference curencies.
class Accpac::Csccd < ActiveRecord::Base
  self.table_name  = 'CSCCD'
  self.primary_key = 'CURID'
end
