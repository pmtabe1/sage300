module Accpac::Poporh1Helper

  def is_complete(po)
    if po.ISCOMPLETE == 1
      content_tag(:span, "Completed", class: "label label-success")
    else
      content_tag(:span, "Incomplete", class: "label label-danger")
    end
  end

  def datatable_filtered_for_open_po
    if current_user.type == "vendor"
      Accpac::Poporh1.open_by_vendor(current_user).count
    else
      Accpac::Poporh1.open.count
    end
  end

  def datatable_filtered
    if current_user.type == "vendor"
      Accpac::Poporh1.by_vendor(current_user).count
    else
      Accpac::Poporh1.count
    end
  end

  def po_on_hold(porhseq)
    if porhseq.ONHOLD == 0
      "False"
    else
      "True"
    end
  end

  def po_type(porhseq)
    if porhseq.PORTYPE == 1
      "Active"
    elsif porhseq.PORTYPE == 2
      "Standing"
    elsif porhseq.PORTYPE == 3
      "Future"
    elsif porhseq.PORTYPE == 4
      "Blanket"
    end
  end

  def purchase_order_link(pouniq, ponumber)
    link_to(ponumber, accpac_poporh1_path(id: pouniq), target: "_blank")
  end
end
