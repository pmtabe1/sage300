# Sage300 Assembly Audit List Details.
class Accpac::Icassmd < ActiveRecord::Base
  self.table_name  = 'ICASSMD'
  self.primary_key = 'DAYENSEQ'

  belongs_to :icassmh, foreign_key: 'DAYENDSEQ'
end
