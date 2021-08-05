module Accpac::IcitemHelper

  # Sales Bar Chart
  def sales_chart_data
    (5.years.ago.to_date.year..Time.now.year).map do |year|
      {
        ORDDATE: year,
        QTYSOLD: Accpac::Oeshdt.where("year(YR) = ? AND ITEM = ?", year, @accpac_icitem.ITEMNO).sum(:QTYSOLD),
        FAMTSALES: Accpac::Oeshdt.where("year(YR) = ? AND ITEM = ?", year, @accpac_icitem.ITEMNO).sum(:FAMTSALES)
      }
    end
  end

  # Availability
  def available(item)
    onhand = Accpac::Iciloc.where("ITEMNO LIKE ?", item.ITEMNO).sum(:QTYONHAND)
    commit = Accpac::Iciloc.where("ITEMNO LIKE ?", item.ITEMNO).sum(:QTYCOMMIT)
    @available = sprintf('%.2f', (onhand - commit)).to_i
  end

  # BOM Availability
  def bom_available(bom)
    onhand = Accpac::Iciloc.where("ITEMNO LIKE ?", bom.COMPONENT).sum(:QTYONHAND)
    commit = Accpac::Iciloc.where("ITEMNO LIKE ?", bom.COMPONENT).sum(:QTYCOMMIT)
    @available = sprintf('%.2f', (onhand - commit))
  end

  def qty_on_scanned(item, location)
    Granite::Document.find_by_sql(
      "SELECT  SUM(DocumentDetail.ActionQty) AS quantity
      FROM #{granite_db}.dbo.Document
        JOIN #{granite_db}.dbo.DocumentDetail ON Document.ID = DocumentDetail.Document_id
        JOIN #{granite_db}.dbo.MasterItem ON MasterItem.ID = DocumentDetail.Item_id
      WHERE Document.Status = 'COMPLETE'
      AND MasterItem.FormattedCode = '#{item}'
      AND Document.ERPLocation = '#{location}'"
    ).map { |v| v.quantity.to_f }
  end

  # Comming Soon Image
  def grid_img_url(item)
    img_url = "http://vertilux-website.s3.amazonaws.com/public/thumb/#{item.ITEMNO.gsub(/\W\s?/, "")}.jpg"
    res = Net::HTTP.get_response(URI.parse(img_url))
    img_url = asset_path 'missing.jpg' unless res.code.to_f >= 200 && res.code.to_f < 400
    image_tag img_url, alt: item.DESC, class: "img-responsive", style: "width: 100%"
  end

  def img_url
    img_url = "http://vertilux-website.s3.amazonaws.com/public/original/#{@accpac_icitem.ITEMNO.gsub(/\W\s?/, "")}.jpg"
    res = Net::HTTP.get_response(URI.parse(img_url))
    img_url = asset_path 'missing.jpg' unless res.code.to_f >= 200 && res.code.to_f < 400
    image_tag img_url, alt: @accpac_icitem.DESC, class: "img-responsive item-picture"
  end

  def related_items_img_url(item)
    img_url = "http://vertilux-website.s3.amazonaws.com/public/thumb/#{item.gsub(/\W\s?/, "")}.jpg"
    res = Net::HTTP.get_response(URI.parse(img_url))
    img_url = asset_path 'missing.jpg' unless res.code.to_f >= 200 && res.code.to_f < 400
    image_tag img_url, alt: item, class: "img-responsive", title: item, 'data-placement' => 'top', rel: :tooltip
  end

  def allow_to_web(allow)
    case allow
    when 1
      "Yes"
    else
      "No"
    end 
  end

  def custom_duty(item)
    Accpac::Icitemo.where(ITEMNO: item, OPTFIELD: "DUTY").pluck(:VALUE).first
  end

  def hts_no_suffix(htsno)
    require 'net/http'
    require 'json'

    url = "https://hts.usitc.gov/api/search?query=#{htsno}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    if data['results'][0].present?
      data = data['results'][0]
      units = data['general']
    else
      "Please check HTS."
    end
  end

  def hts_duty(htsno)
    require 'net/http'
    require 'json'

    url = "https://hts.usitc.gov/api/search?query=#{htsno}"
    uri = URI(url)
    status_response = Net::HTTP.get_response(uri)

    if status_response.kind_of? Net::HTTPSuccess
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      if data['results'][0].present?
        data = data['results'][0]
        units = data['general']
        case units
        when ""
          hts_no_suffix(data['htsno'][0..9])
        else
          units
        end
      else
        "Please check HTS."
      end
    else
      '<span class="label label-danger"><i class="fa fa-arrow-circle-o-down"></i> Down</span>'.html_safe
    end
  end

  def item_gross_weight(item)
    Accpac::Icitemo.where(ITEMNO: item, OPTFIELD: "GROSSW").pluck(:VALUE).first
  end

  def item_link(item)
    link_to(item, accpac_icitem_path(id: item.delete('-')), target: "_blank")
  end

  def avg_unit_cost(transaction)
    number_with_precision((transaction.SRCEXTCST/transaction.QUANTITY), precision: 6).to_f
  end

  def item_sales_rank_color(item)
    case item.item_rank.abc_sales_rank
    when "A"
      'gold'
    when "B"
      'silver'
    when "C"
      'bronze'
    end
  end

  def item_margin_rank_color(item)
    case item.item_rank.abc_margin_rank
    when "A"
      'gold'
    when "B"
      'silver'
    when "C"
      'bronze'
    end
  end

  def item_cost_rank_color(item)
    case item.item_rank.abc_cost_rank
    when "A"
      'gold'
    when "B"
      'silver'
    when "C"
      'bronze'
    end
  end

  def low_stock_items
    Views::ItemCompanyDetail.where("COVERAGE < ? AND QTYONORDER = ? AND PRODUCTION = ?", 4.5, 0, 0)
  end

  def shipping_documents(porhseq, itemno)
    DocumentLine.find_by_sql("SELECT d.id, dt.name, dl.quantity, dl.price, dl.ext_price, d.updated_at,
      JSON_VALUE(properties_column, '$.\"Estimated Time of Delivery (ETD)\"') AS etd,
      JSON_VALUE(properties_column, '$.\"On Board Date\"') AS obd,
      JSON_VALUE(properties_column, '$.\"Estimated Time of Arrival (ETA)\"') AS eta,
      JSON_VALUE(properties_column, '$.\"Container Number\"') AS container,
      JSON_VALUE(properties_column, '$.\"AWB Number\"') AS awb
    FROM document_lines dl
      JOIN documents d ON dl.document_id = d.id
      JOIN document_types dt ON d.document_type_id = dt.id
    WHERE dl.porhseq = #{porhseq} AND dl.itemno = '#{itemno}'
    AND dt.name IN ('Proforma Invoice', 'Commercial Invoice')
    ORDER BY id DESC")
  end

  def upcomming_documents(itemno)
    DocumentLine.find_by_sql("SELECT dl.itemno, d.uuid, d.document_id AS invoice, SUM(dl.quantity) AS quantity,
      JSON_VALUE(properties_column, '$.\"Estimated Time of Delivery (ETD)\"') AS etd,
      JSON_VALUE(properties_column, '$.\"Estimated Time of Arrival (ETA)\"') AS eta
    FROM document_lines dl
    JOIN documents d ON dl.document_id = d.id
    WHERE dl.itemno = '#{itemno}'
      AND JSON_VALUE(properties_column, '$.\"Estimated Time of Arrival (ETA)\"') IS NOT NULL
      AND JSON_VALUE(properties_column, '$.\"Estimated Time of Arrival (ETA)\"') >= DATEADD(DD,-10,GETDATE())
      AND d.document_type_id = 7
    GROUP BY dl.itemno, d.document_id, d.uuid,
      JSON_VALUE(properties_column, '$.\"Estimated Time of Arrival (ETA)\"'),
      JSON_VALUE(properties_column, '$.\"Estimated Time of Delivery (ETD)\"')
    ORDER BY JSON_VALUE(properties_column, '$.\"Estimated Time of Arrival (ETA)\"') DESC")
  end

  def container(document)
    if Document.where("document_id LIKE ?", "%#{document}%").present?
      Document.where("document_id LIKE ?", "%#{document}%").map { |c| c.properties_column['Container Number'] || c.properties_column['AWB Number'] }.compact.join('')
    end
  end

  def container_to_location(document)
    purchase_orders = Document.find(document).purchase_orders
    Accpac::Poporh2.where(PORHSEQ: purchase_orders.reject(&:empty?)).pluck(:STCODE).uniq.compact.join('- ')
  end

  def on_board_date(document)
    if Document.where("document_id LIKE ?", "%#{document}%").present?
      Document.where("document_id LIKE ?", "%#{document}%").map { |c| c.properties_column['On Board Date'] }.compact.join('')
    end
  end

  def arrival_date(document)
    if Document.where("document_id LIKE ?", "%#{document}%").present?
      eta = Document.where("document_id LIKE '%#{document}%' AND document_type_id IN ('7','11')").map { |c| c.properties_column['Estimated Time of Arrival (ETA)'] }
      if eta.count > 1
        "#{eta.first} <i class='fa fa-check'><i> <a data-container='body' data-toggle='popover' data-placement='top' data-trigger='hover' data-title='Warning' data-content='This shipment has two Bill of Lading, please check shipping documents.'> <i class='fa fa-warning' aria-hidden='true'></i>".html_safe
      else
        if eta.present? && eta.first < (Time.now - 10.days)
          "#{eta.first} <i class='fa fa-check'><i>".html_safe
        else
          eta.first
        end
      end
    end
  end

  # Direct shipments calculations from China
  def cost_direct_shipments_china(item)
    lme = DailyLme.current.first.try(:lme)
    smm = DailyLme.current.first.try(:smm)
    rate = DailyLme.current.first.try(:oanda)
    lme_ave = (lme+(smm/rate))/2

    properties = item.product_properties.sum("CAST(COALESCE(value, '0') AS DECIMAL)").to_f
    kgm = item.UNITWGT/(2.20462/3.2808).to_f 

    cost = ((lme_ave.to_f+properties)*kgm.to_f)*(1/3.28084)/1000
  end

  def price_direct_shipments_china(item)
    (cost_direct_shipments_china(item)*1.15)/0.8
  end

  # Direct shipments calculations NOT from China
  def cost_direct_shipments(item)
    lme = DailyLme.current.first.try(:lme)

    properties = item.product_properties.sum("CAST(COALESCE(value, '0') AS DECIMAL)").to_f
    kgm = item.UNITWGT/(2.20462/3.2808).to_f 

    cost = ((lme+properties)*kgm.to_f)*(1/3.28084)/1000
  end

  def price_direct_shipments(item)
    (cost_direct_shipments(item)*1.15)/0.8
  end
end
