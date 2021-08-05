# Sage300 Sistem Table fro Item Change
class Accpac::Siaud < ActiveRecord::Base
  self.table_name  = 'SIAUD'
  self.primary_key = 'OLDITEMNO'
end
