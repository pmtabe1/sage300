# Sage300 Optional Fields table.
# Primary key: OPTFIELD (Optional Field).
class Accpac::Csoptfh < ActiveRecord::Base
  self.table_name  = 'CSOPTFH'
  self.primary_key = 'OPTFIELD'
end
