# Sage300 table Return Authorization Details.
class Accpac::Radet < ActiveRecord::Base
  self.table_name  = 'RADET'
  self.primary_key = 'RMAUNIQ'

  # Associaiton with Return Authorizations.
  belongs_to :rahead, foreign_key: 'RMAUNIQ'
end
