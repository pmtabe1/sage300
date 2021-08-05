class Accpac::OeordhController < ApplicationController
  before_action :set_accpac_oeordh, only: [:show, :details]
  before_action :authorize_read_sales_order, only: [:show]
  include ApplicationHelper

  def index
    respond_to do |format|
      format.html
      authorize! :index, @accpac_oeordh, format.json { render json: Accpac::OeordhDatatable.new(view_context) }
    end
  end

  # Oorder action report, this method include the pivot by locations 
  # to lists the locations availability in columns.
  def order_action_report
    @order_action_report = Views::OrderActionReport.all
  end

  # Custom report for sales team, include all open orders.
  def order_action
    @order_action = Views::OrderAction.all.each
  end

  # Sales orders fulfillanle.
  def fulfillable
    @fulfillable = Views::OrderAction.where("REFERENCE IS NULL AND FULFILLQTY > 0")
  end

  # Sales orders backorders.
  def backorders
    @backorders = Views::OrderAction.where("BACKORDQTY > 0")
  end

  # Sales orders that needs to be transfers to another location in 
  # order to be able to fulfill.
  def transfer_demand
    @transfer_demand = Views::OrderAction.having('SUM(QTYORDERED) > LOCSTOCK').group("ITEM, [DESC], ORDUNIQ, ORDNUMBER,
      LOCATION, CUSTOMER, CUSTNAME, SALESREP, ORDDATE, QTYORDERED, QTYCOMMIT, ORDAMOUNT, CUSTGROUP, OPTFCAT, OPTFDEPT, OPTFPROD,
      OPTFTYPE, CATDESC, CATEGORY, LOCSTOCK, COMPSTOCK, BACKORDQTY, FULFILLQTY, OPENORDQTY, REFERENCE, REFID, REFDATE, REFSTATUS,
      PONUMBER, SOREFERENCE, MRCAMOUNT, CODECTRY, abc_sales_rank, dense_sales_rank, abc_cost_rank, dense_cost_rank,
      abc_margin_rank, dense_margin_rank")
  end

  def show
    #authorize! :read, @accpac_oeordh
    authorize! :read, @accpac_arcus
		respond_to do |format|
			format.html
	 		format.csv
	 		format.xls
		end
  end

  # Miscellneous charges view.
  def miscellaneous_charges
    @miscellaneous_charges = Accpac::Oeinvh.find_by_sql("
      SELECT
          OEINVH.CUSTOMER, OEINVH.INVDATE, OEINVH.BILNAME, OEINVH.INVNUMBER,
          OEINVH.ORDNUMBER, OEINVH.SHIPTRACK, OEINVH.LOCATION, OEINVH.SHPSTATE,
          OEINVH.SHPCOUNTRY, OEINVH.SHIPVIA, OEINVH.INVFISCYR, OEINVH.INVFISCPER,
          OEINVH.INVNETWTX, OEINVD.MISCCHARGE, OEMISC.[DESC], OEMISC.MISCACCT,
          OEINVD.EXTINVMISC, OEINVH.SALESPER1, OEINVH.TERRITORY, OEINVH.VIADESC
      FROM OEINVH
      JOIN OEINVD ON OEINVH.INVUNIQ = OEINVD.INVUNIQ
      JOIN OEMISC ON OEINVD.MISCCHARGE = OEMISC.MISCCHARGE
      WHERE DATEADD(MONTH, -36, GETDATE()) <= CONVERT(DATE,NULLIF(CONVERT(VARCHAR(10),CONVERT(INT,OEINVD.AUDTDATE)),0))
    ")
  end

  # Async load of the saels orders details (item lines).
  def details
    render :partial => 'details'
  end

  # Async load of shipments realted to the sales order.
  def shipment
    render :partial => 'shipments'
  end

  # Async load of invoices realted to the sales order.
  def invoices
    render :partial => 'invoices'
  end

  # Report of sales orders entered by users.
  def users_report
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
    def set_accpac_oeordh
      @accpac_oeordh = Accpac::Oeordh.find(params[:id])
    end

    def set_accpac_oeordd
      @accpac_oeordd = Accpac::Oeordd.select("ORDUNIQ", "ITEM", "LOCATION", "QTYORDERED", "QTYCOMMIT", "QTYSHIPPED")
    end

    def authorize_read_sales_order
      @accpac_arcus = Accpac::Arcus.find(@accpac_oeordh.CUSTOMER)
    end
end
