# Sage300 Assembly Audit List Headers.
class Accpac::Icassmh < ActiveRecord::Base
  self.table_name  = 'ICASSMH'
  self.primary_key = 'DAYENDSEQ'

  belongs_to :icasen, foreign_key: 'DOCNUM'
  has_many :icassmd, foreign_key: 'DAYENDSEQ'
end
