# OpenPurchaseOrder is a scenic view, this view simple list 
# all open purchase orders along with their Packing List and 
# Proforma Invoice (both form Document model).
module Views
  class OpenPurchaseOrder < ActiveRecord::Base
    self.table_name  = 'open_purchase_orders'
    self.primary_key = 'PORHSEQ'
  end
end
