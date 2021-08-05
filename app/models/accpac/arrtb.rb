# Sage300 customer's Terms Payment Schedules table.
# Primary key: CODETERM (Terms Code).
class Accpac::Arrtb < ActiveRecord::Base
  self.table_name  = 'ARRTB'
  self.primary_key = 'CODETERM'

  # Association with customer's documents.
  has_many :arobl, foreign_key: 'CODETERM'
end
