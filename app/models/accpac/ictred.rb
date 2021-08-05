# Sage300 table Transfer Details.
class Accpac::Ictred < ActiveRecord::Base
  self.table_name  = 'ICTRED'
  self.primary_key = 'TRANFENSEQ'

  # Association with Transfer Headers and Transfer Audit List Headers.
  belongs_to :ictranh, foreign_key: 'TRANFENSEQ'
  belongs_to :ictreh, foreign_key: 'TRANFENSEQ'
end
