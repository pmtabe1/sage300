module Accpac::OeordhHelper

  def scanned_qty(order)
    document = Granite::Document.find_by(Number: @accpac_oeordh.ORDNUMBER).ID
    item = Granite::MasterItem.find_by(FormattedCode: order.ITEM).ID
    scanned = Granite::DocumentDetail.where(Document_id: document, Item_id: item).first.try(:ActionQty)
  end

  def date_time(order)
    date = order.ORDDATE.to_s.insert(4, '-').insert(7, '-')
    time = order.AUDTTIME.to_s.insert(2, ':').insert(5, ':')[0..-3]
    date_time = ((date + " " + time).to_datetime-4.hours).strftime("%H:%M")
  end

  def fulfillment_data
    Views::Fulfillment.select('ITEM', 'ORDNUMBER').all.map do |row|
      {
        ITEM: row.ITEM,
        ORDNUMBER: row.ORDNUMBER
      }
    end
  end

  def on_hold(orduniq)
    if orduniq.ONHOLD == 0
      "False"
    else
      "True"
    end
  end

  def order_type(orduniq)
    if orduniq.TYPE == 1
      "Active"
    elsif orduniq.TYPE == 2
      "Future"
    elsif orduniq.TYPE == 3
      "Standing"
    elsif orduniq.TYPE == 4
      "Quote"
    end
  end

  def order_link(orduniq, ordnumber)
    link_to(ordnumber, accpac_oeordh_path(id: orduniq), target: "_blank")
  end

  def reference_link(id, number)
    if id.present?
      link_to(number, shipping_reference_path(id: id), target: "_blank")
    end
  end

  def order_action_total_qty_location(sales_order)
    miami = sales_order.Loc1.to_f + sales_order.Loc1L.to_f
    free_zone = sales_order.Loc10.to_f + sales_order.Loc10L.to_f + sales_order.Loc10M.to_f
    west = sales_order.Loc5L.to_f + sales_order.Loc4D.to_f
    special = sales_order.Loc2D.to_f + sales_order.Loc2M.to_f + sales_order.Loc9.to_f + sales_order.Loc12.to_f
    @total = miami + free_zone + west + special
  end

  def order_action_gp(sales_order)
    ((sales_order.UNITPRICE-sales_order.UNITCOST)/sales_order.UNITPRICE)*100
  end

  def sales_order_gross_margin(sales_order)
    most_recent_cost = sales_order.oeordd.sum(:EXTOCOST)
    order_total = @accpac_oeordh.INVNETWTX 
    ((order_total - most_recent_cost)/order_total)*100
  end

  def sales_order_line_gross_margin(price, cost)
    ((price - cost)/price)*100
  end

  def datatable_filtered_for_open_so
    if current_user.type == "customer"
      Accpac::Oeordh.open_by_customer(current_user).count
    else
      Accpac::Oeordh.open.count
    end
  end

  def open_orders?
    if params[:open].present?
      accpac_oeordh_index_url(open: "true", format: "json")
    else
      accpac_oeordh_index_url(format: "json")
    end
  end

end
