# Sage300 Assemblies table.
class Accpac::Icasen < ActiveRecord::Base
  self.table_name  = 'ICASEN'
  self.primary_key = 'DOCNUM'

  has_many :icassmh, foreign_key: 'DOCNUM'
  has_many :icassmd, through: :icassmh
end
