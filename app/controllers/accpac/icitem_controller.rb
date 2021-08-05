class Accpac::IcitemController < ApplicationController
  before_action :set_accpac_icitem, only: [:show, :update, :icitem_availability,
    :vendors, :containers, :icitem_sales, :locations, :sales_orders, :transfers,
    :documents, :transactions, :sales_history, :purchase_orders_history, :alternate_items,
    :icitem_optional_fields, :optional_fields]
  before_action :set_purchase_orders, only: [:documents]

  # Sales Orders & Purchase Orders
  include ApplicationHelper

  def index
    respond_to do |format|
      format.html
      format.json { render json: Accpac::IcitemDatatable.new(view_context) }
      format.js
    end

    @items = Accpac::Icitem.paginate(page: params[:page], per_page: 20).order(ITEMNO: :asc)
  end

  def duties
    respond_to do |format|
      format.html
      format.json { render json: Accpac::DutiesDatatable.new(view_context) }
    end
  end

  def update
    respond_to do |format|
      if @accpac_icitem.update(accpac_icitem_params)
        format.html { redirect_to accpac_icitem_path(@accpac_icitem) }
      else
        format.html { redirect_to accpac_icitem_path(@accpac_icitem), aler: 'Unabled to update Item, please try again later.' }
      end
    end
  end

  def show
    @prev_item = @accpac_icitem.previous
    @next_item = @accpac_icitem.next
    @related_items = Accpac::Icitem.where("SEGMENT3 LIKE ? AND CATEGORY LIKE ?", @accpac_icitem.SEGMENT3, @accpac_icitem.CATEGORY).where.not(ITEMNO: @accpac_icitem.ITEMNO).all
  end

  def locations
    @locations = Accpac::Iciloc.find_by_sql(
      "SELECT  ICILOC.LOCATION, QTYONHAND, QTYSALORDR, QTYONORDER, QTYCOMMIT, RECENTCOST, TOTALCOST,
        TOWYEARSQTY, FOURQUARTERQTY, THIRDQUARTERQTY, SECONDQUARTERQTY, FIRSTQUARTERQTY,
        CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(DECIMAL,ICILOC.LASTSHIPDT)),0)) AS LAST_SHIPDT,
        CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(DECIMAL,ICILOC.LASTRCPTDT)),0)) AS LAST_RCPTDT,
        (QTYONHAND - QTYCOMMIT) AS AVAILABLE, DAYSTOSHIP, UNITSSHIP, STDCOST, LASTCOST, abc_sales_rank, dense_sales_rank,
          ISNULL((SELECT SUM(ICTRED.QTYREQ) FROM dbo.ICTREH
            JOIN dbo.ICTRED ON ICTRED.TRANFENSEQ = ICTREH.TRANFENSEQ
            WHERE ICTREH.STATUS <> 20
              AND REPLACE(ICTRED.ITEMNO,'-','') = ICILOC.ITEMNO
              AND ICTRED.FROMLOC = ICILOC.LOCATION
            GROUP BY ICTRED.ITEMNO, ICTRED.FROMLOC),0) AS TRANSOUT,
          ISNULL((SELECT SUM(ICTRED.QTYREQ) FROM dbo.ICTREH
            JOIN dbo.ICTRED ON ICTRED.TRANFENSEQ = ICTREH.TRANFENSEQ
            WHERE ICTREH.STATUS <> 20
              AND REPLACE(ICTRED.ITEMNO,'-','') = ICILOC.ITEMNO
              AND ICTRED.TOLOC = ICILOC.LOCATION
            GROUP BY ICTRED.ITEMNO, ICTRED.TOLOC),0) AS TRANSIN
      FROM dbo.ICILOC
      LEFT JOIN dbo.ItemsRankingLocation ON ICILOC.ITEMNO = ItemsRankingLocation.item AND ICILOC.LOCATION = ItemsRankingLocation.location
      LEFT JOIN ItemsMovingAve ON ItemsMovingAve.ITEMNO = ICILOC.ITEMNO AND ItemsMovingAve.LOCATION = ICILOC.LOCATION
      WHERE ICILOC.ITEMNO = '#{@accpac_icitem.ITEMNO}'
      ORDER BY ICILOC.[LOCATION] ASC")
  end

  def transfers
    @transfers = Accpac::Ictred.select('TRANFENSEQ', 'DOCNUM', 'HDRDESC',
      'CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(DECIMAL,ICTREH.TRANSDATE)),0)) AS TRANS_DATE',
      'FROMLOC', 'TOLOC', 'GITLOC', 'UNIT', 'QTYREQ', 'QUANTITY', 'ENTEREDBY'
      ).joins(:ictreh).where(ITEMNO: @accpac_icitem.FMTITEMNO, COMPLETE: 0).where.not('ICTREH.STATUS = ?', 20)
    render json: @transfers
  end

  def sales_orders
    @sales_orders = Accpac::Oeordd.find_by_sql(
      "SELECT OEORDH.ORDUNIQ, ORDNUMBER, CUSTOMER, BILNAME, CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(DECIMAL,OEORDH.ORDDATE)),0)) AS ORD_DATE,
        OEORDD.LOCATION, ORDUNIT, UNITPRICE, QTYORDERED, QTYCOMMIT, QTYSHIPPED, SALESPER1,
      CASE OEORDH.[TYPE]
        WHEN 1 THEN 'Active'
        WHEN 2 THEN 'Future'
        WHEN 3 THEN 'Standing'
      ELSE 'Quote'
      END AS ORDTYPE, ONHOLD
      FROM dbo.OEORDD
      JOIN dbo.OEORDH ON OEORDD.ORDUNIQ = OEORDH.ORDUNIQ
        WHERE OEORDD.ITEM = '#{@accpac_icitem.FMTITEMNO}'
        AND OEORDD.COMPLETE = 0")
  end

  def documents
    render :partial => "documents"
  end

  def transactions
    @transactions = @accpac_icitem.ichist.all
  end

  def sales_history
    @sales_history = Accpac::Oeshdt.find_by_sql("
      SELECT s.CUSTOMER, c.NAMECUST, s.LOCATION, s.YR, s.PERIOD, s.ORDNUMBER,
      s.ORDDATE, s.SHIPDATE, s.SHINUMBER, s.TERRITORY, s.QTYSOLD, s.FAMTSALES
      FROM OESHDT s
      JOIN ARCUS c ON s.CUSTOMER = c.IDCUST
      WHERE s.ITEM = '#{@accpac_icitem.ITEMNO}'
    ")
  end

  def purchase_orders_history
    @purchase_orders_history = Accpac::Pohstl.find_by_sql("
      SELECT p.VENDOR, v.VENDNAME, p.[LOCATION], p.FISCYEAR, p.FISCPERIOD,
        p.TRANSDATE, p.TRANSTYPE, p.DOCNUMBER, p.UNIT, p.RQPOSTED,
        p.SCEXTENDED
      FROM POHSTL p
      JOIN APVEN v ON p.VENDOR = v.VENDORID
      WHERE p.ITEMNO = '#{@accpac_icitem.ITEMNO}'
    ")
  end

  def related_items
    @similar_items = Accpac::Icitem.where("SEGMENT3 LIKE ? AND CATEGORY LIKE ?",
      @accpac_icitem.SEGMENT3, @accpac_icitem.CATEGORY).where.not(ITEMNO: @accpac_icitem.ITEMNO)
    render :partial => "related_items"
  end

  def vendors
    render :partial => "vendor"
  end

  def coverage
    @accpac_icitem = Accpac::Icitem.find(params[:id])
    render :partial => "coverage"
  end

  def all_companies_stock
    @accpac_icitem = Accpac::Icitem.find(params[:id])
    render :partial => "all_companies_stock"
  end

  def optional_fields
    render :partial => "optional_fields"
  end

  def alternate_items
    @alternate_items = Accpac::Icitem.where(ALTSET: @accpac_icitem.ALTSET).where.not(ITEMNO: @accpac_icitem.ITEMNO).all
    render :partial => "alternate_items"
  end

  def icitem_optional_fields
    @optional_fields = @accpac_icitem.icitemo.all
    render :partial => "optional_fields"
  end

  def inventory_diff
    @difference = Views::InventoryDiff.all
  end

  def location_diff
    @difference = Views::LocationDiff.all.order(ITEMNO: :asc)
  end

  def inv_vs_sales
    @inv_vs_sales = vtx_client.inv_vs_sales_by_locations(server: CONFIG['server'], db_name: company_id)
  end

  def moving_average
    @moving_average = Views::ItemsMovingAverage.all
  end

  def item_location_detail
    @item_location_detail = Views::ItemLocationDetail.all
  end

  def item_company_detail
    @item_company_detail = Views::ItemCompanyDetail.all
  end

  private
    def accpac_icitem_params
      params.require(:accpac_icitem).permit(product_properties_attributes: [:id, :value, :itemno, :property_id, :_destroy])
    end

    def set_accpac_icitem
      @accpac_icitem = Accpac::Icitem.find(params[:id])
    end

    def set_purchase_orders
      @purchase_orders = Accpac::Poporl.find_by_sql(
        "SELECT POPORH1.PORHSEQ, PONUMBER, ITEMNO, VDCODE, VDNAME, POPORL.LOCATION, ORDERUNIT, UNITCOST,
          POPORL.EXTENDED, POPORL.OQORDERED, POPORL.SQOUTSTAND,
          CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10), CONVERT(DECIMAL,POPORH1.DATE)),0)) AS PD_DATE,
          CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(DECIMAL,POPORL.EXPARRIVAL)),0)) AS EXP_ARRIVAL,
        CASE PORTYPE
          WHEN 1 THEN 'Active'
          WHEN 2 THEN 'Standing'
          WHEN 3 THEN 'Future'
        ELSE 'Blanket'
        END AS PORTYPE
        FROM dbo.POPORL
        JOIN dbo.POPORH1 ON POPORL.PORHSEQ = POPORH1.PORHSEQ
        WHERE POPORL.ITEMNO = '#{@accpac_icitem.FMTITEMNO}'
        AND POPORL.COMPLETION = 1
        ORDER BY POPORH1.DATE ASC"
      )
    end
end
