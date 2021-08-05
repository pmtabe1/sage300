# Sage300 table Sales History Details.
class Accpac::Oeshdt < ActiveRecord::Base
  self.table_name  = 'OESHDT'

  # Association with Custoemr and Items
  belongs_to :arcus, foreign_key: 'CUSTOMER', class_name: "Arcus"
  belongs_to :icitem, foreign_key: 'ITEMNO'

  # Scopes to filter by Sales Persons and Custopmers.
  scope :sales_rep, lambda { |user| where(SALESPER: user.arsap) }
  scope :customer, lambda { |user| where(CUSTOMER: user.customer_id) }
end
