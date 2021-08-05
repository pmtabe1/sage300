module PagesHelper

  # total sales by periods
  def total_sales_periods
    (1..12).map do |month|
      {
        MONTHS: month.to_s,
        CURRENT: Accpac::Oeshdt.where(PERIOD: month, YR: current_year).sum(:FAMTSALES),
        LAST: Accpac::Oeshdt.where(PERIOD: month, YR: last_year).sum(:FAMTSALES),
      }
    end
  end

  # Shipping References Counter
  def new_shipping_reference_count
    if current_user.dept_area == 'customer_service' || current_user.dept_area == 'purchasing'
      current_user.shipping_references.new_reference.count
    elsif current_user.dept_area == 'warehouse'
      ShippingReference.new_by_location(current_user).count
    else
      @new_references_count = ShippingReference.new_reference.count
    end
  end

  def prepare_shipping_reference_count
    if current_user.dept_area == 'customer_service' || current_user.dept_area == 'purchasing'
      current_user.shipping_references.prepare_reference.count
    elsif current_user.dept_area == 'warehouse'
      ShippingReference.prepare_by_location(current_user).count
    else
      @prepare_references_count = ShippingReference.prepare_reference.count
    end
  end

  def pack_shipping_reference_count
    if current_user.dept_area == 'customer_service' || current_user.dept_area == 'purchasing'
      current_user.shipping_references.pack_reference.count
    elsif current_user.dept_area == 'warehouse'
      ShippingReference.pack_by_location(current_user).count
    else
      @pack_references_count = ShippingReference.pack_reference.count
    end
  end

  def dispatch_shipping_reference_count
    if current_user.dept_area == 'customer_service' || current_user.dept_area == 'purchasing'
      current_user.shipping_references.dispatch_reference.count
    elsif current_user.dept_area == 'warehouse'
      ShippingReference.dispatch_by_location(current_user).count
    else
      @dispatch_references_count = ShippingReference.dispatch_reference.count
    end
  end

  def picklabels_without_action
    Granite::Document.find_by_sql(
      "SELECT  MasterItem.Code, SUM(TrackingEntity.Qty) AS PickQuantity, DocumentDetail.ActionQty,
        [Transaction].Process, Document.Number, Document.TradingPartnerCode, Document.AuditDate, ERPLocation
      FROM #{granite_db}.dbo.CarryingEntity
        JOIN #{granite_db}.dbo.TrackingEntity ON TrackingEntity.BelongsToEntity_id = CarryingEntity.ID
        JOIN #{granite_db}.dbo.Document ON TrackingEntity.DocumentLink_id = Document.ID
        JOIN #{granite_db}.dbo.DocumentDetail ON  Document.ID = DocumentDetail.Document_id
        JOIN #{granite_db}.dbo.MasterItem ON TrackingEntity.MasterItem_id = MasterItem.ID
        JOIN #{granite_db}.dbo.[Transaction] ON [Transaction].TrackingEntity_id = TrackingEntity.ID
      WHERE Process = 'PICKLABEL'
      AND TrackingEntity.MasterItem_id= DocumentDetail.Item_id
      AND TrackingEntity.DocumentLink_id = Document.ID
      GROUP BY MasterItem.Code, [Transaction].Process, DocumentDetail.ActionQty,
      Document.Number, Document.AuditDate, Document.TradingPartnerCode, ERPLocation
      HAVING SUM(TrackingEntity.Qty) > DocumentDetail.ActionQty
      ORDER BY TradingPartnerCode ASC"
    )
  end

end
