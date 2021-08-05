# Sage300 Accounts table.
# Primary key: ACCTID (Account Number).
class Accpac::Glamf < ActiveRecord::Base
  self.table_name  = 'GLAMF'
  self.primary_key = 'ACCTID'

  # Association with Account FIscal Set and Account Groups.
  belongs_to :glafs, foreign_key: 'ACCTID'
  belongs_to :glacgrp, foreign_key: 'ACCTGRPCOD'
  has_many :glafs, foreign_key: 'ACCTID', class_name: "Glafs"
end
