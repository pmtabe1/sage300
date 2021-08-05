class Accpac::ArcusController < ApplicationController
  before_action :set_accpac_arcus, only: [
    :show, :customer_sales_report, :sales_history, :opened_orders,
    :price_lists, :backorders, :fulfillable, :documents, :receivable,
    :statistics, :miscellaneous_charges, :budget
  ]
  include ApplicationHelper

  def index
    respond_to do |format|
      format.html
      format.json { render json: Accpac::ArcusDatatable.new(view_context) }
    end
  end

  def map
    @customers = Address.find_by_sql("
      SELECT
        uniq, NAMECUST AS name, street, city, zip, state, latitude, longitude,
          (SELECT SUM(FAMTSALES-FRETSALES)
            FROM OESHDT AS s
            WHERE (a.uniq = CUSTOMER) AND PERIOD <= #{Time.now.month} AND YR = #{last_year}) AS last_year_netsales,
          (SELECT SUM(FAMTSALES-FRETSALES)
            FROM OESHDT AS s
            WHERE (a.uniq = CUSTOMER) AND PERIOD <= #{Time.now.month} AND YR = #{current_year}) AS current_year_netsales
      FROM addresses AS a
      JOIN ARCUS ON IDCUST = uniq
      WHERE SWACTV = 1
      GROUP BY uniq, NAMECUST, street, city, zip, state, latitude, longitude")
  end

  def show
  end

  def sales_history
    @sales_history = Accpac::Oeshdt.find_by_sql("
      SELECT
        sh.ITEM, i.FMTITEMNO, i.[DESC], i.CATEGORY, sh.TRANNUM AS INVOICE, sh.ORDNUMBER,
        sh.PONUMBER, sh.LOCATION, sh.YR, sh.PERIOD, sh.QTYSOLD, sh.FAMTSALES AS SALES,
        sh.FRETSALES AS RETURNS, (sh.FAMTSALES-sh.FRETSALES) AS NETSALES
      FROM OESHDT sh
      JOIN ICITEM i ON i.ITEMNO = sh.ITEM
      WHERE CUSTOMER = '#{@accpac_arcus.IDCUST}'
      AND YR > #{current_year.to_i - 5}
      ORDER BY sh.AUDTDATE DESC"
    )
  end

  def opened_orders
    @opened_orders = @accpac_arcus.order_action
  end

  def backorders
    @backorders = @accpac_arcus.order_action.backorder
  end

  def fulfillable
    @fulfillable = @accpac_arcus.order_action.fulfillable
  end

  def debts
    @customer_dues = Views::UnpaidReceivable.all
  end

  def price_lists
    @price_lists = Accpac::Icpricp.find_by_sql("
      SELECT PRICELIST, ICPRICP.ITEMNO, FMTITEMNO, [DESC], CITEMNO, CITEMDESC,
        COMMODIM, DPRICETYPE, QTYUNIT, ICPRICP.AUDTDATE, ICPRICP.AUDTUSER,
        UNITPRICE, LASTPRICDT, PREVPRICE
      FROM ICPRICP
      JOIN ICITEM ON ICITEM.ITEMNO = ICPRICP.ITEMNO
      LEFT JOIN ICITMC ON ICITEM.ITEMNO = ICITMC.ITEMNO
      WHERE PRICELIST = '#{@accpac_arcus.PRICLIST}'
    ")
  end

  def documents
    @documents = @accpac_arcus.arobl.order(DATEINVC: :desc)
  end

  def receivable
    @receivable = @accpac_arcus.unpaid_receivable.u30.sum(:INAMTOVER)
    render json: @receivable
  end

  def statistics
    respond_to do |format|
      format.js
    end
  end

  def miscellaneous_charges
    @miscellaneous_charges = Accpac::Oeinvh.find_by_sql("
      SELECT
          OEINVH.CUSTOMER, OEINVH.BILNAME, OEINVH.INVNUMBER, OEINVH.LOCATION,
          OEINVH.TERRITORY, OEINVH.SHPSTATE, OEINVH.SHPCOUNTRY, OEINVH.SHIPVIA,
          OEINVH.INVFISCYR, OEINVH.INVFISCPER, OEINVD.MISCCHARGE, OEMISC.[DESC],
          OEMISC.MISCACCT, OEINVD.EXTINVMISC, OEINVH.SALESPER1
      FROM OEINVH
      JOIN OEINVD ON OEINVH.INVUNIQ = OEINVD.INVUNIQ
      JOIN OEMISC ON OEINVD.MISCCHARGE = OEMISC.MISCCHARGE
      WHERE OEINVH.CUSTOMER = '#{@accpac_arcus.IDCUST}'
    ")
  end

  private
    def set_accpac_arcus
      @accpac_arcus = Accpac::Arcus.find(params[:id])
    end
end
