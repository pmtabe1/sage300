# Sage300 table	Transfer Headers.
class Accpac::Ictreh < ActiveRecord::Base
  self.table_name  = 'ICTREH'
  self.primary_key = 'TRANFENSEQ'
  
  # Association with Transfer Details.
  has_many :ictred, foreign_key: 'TRANFENSEQ'
end
