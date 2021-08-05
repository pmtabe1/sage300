# Sage300 table Invoice Details.
class Accpac::Oeinvd < ActiveRecord::Base
  self.table_name  = 'OEINVD'
  self.primary_key = 'INVUNIQ'

  # Association with Invoices.
  belongs_to :oeinvh, foreign_key: 'INVUNIQ'

  # This method is use to identify misscelaneous items.
  def item_order
    if self.ITEM.present?
      "#{self.ITEM} - #{self.ORDNUMBER}"
    else
      "MISC - #{self.ORDNUMBER}"
    end
  end
end
