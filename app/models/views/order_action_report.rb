# This scenic view along with the on_hand_pivot display open 
# sales orders and the availability in all physical locations.
module Views
  class OrderActionReport < ActiveRecord::Base

    self.table_name  = 'order_action_report'
    self.primary_key = 'ORDUNIQ'

    # Scope with lamda function to filter by sales person.
    scope :by_sales_person, lambda { |user| where(SALESREP: user.arsap) }
    
    # Association with Sage300 tables (sales persons, customers and items)
    belongs_to :arsap, foreign_key: 'SALESREP'
    belongs_to :arcus, foreign_key: 'CUSTOMER', class_name: "Arcus"
    belongs_to :icitem, foreign_key: 'ITEM'

  end
end
