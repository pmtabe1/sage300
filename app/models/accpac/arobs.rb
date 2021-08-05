# Sage300 customer's Document Sched. payments.
# Primary key: IDCUST (Customer Number).
class Accpac::Arobs < ActiveRecord::Base
  self.table_name  = 'AROBS'
  self.primary_key = 'IDCUST'

  # Association with customers.
  belongs_to :customer, foreign_key: 'IDCUST'

  # Scope to filter pending documents by registered users 
  # that are associated with Sage customers.
  scope :pending_by_customer, lambda { |user| where(TXTTRXTYPE: 1, SWPAID: 0, IDCUST: user.customer_id) }
end
