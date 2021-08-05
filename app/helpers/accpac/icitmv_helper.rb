module Accpac::IcitmvHelper

  def item_description(item)
    Accpac::Icitem.find(item.ITEMNO).DESC
  end

  def item_formatted(item)
    Accpac::Icitem.find(item.ITEMNO).FMTITEMNO
  end

  def datatable_filtered
    if current_user.type == "vendor"
      Accpac::Icitmv.by_vendor(current_user).count
    else
      Accpac::Icitmv.count
    end
  end
end
