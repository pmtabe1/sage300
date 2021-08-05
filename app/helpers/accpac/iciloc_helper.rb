module Accpac::IcilocHelper

  def item_desc(item)
    Accpac::Icitem.find(item.ITEMNO).DESC
  end

end
