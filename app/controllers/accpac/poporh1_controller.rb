class Accpac::Poporh1Controller < ApplicationController
  before_action :set_accpac_poporh1, only: [:show, :print, :time_line, :details]
  before_action :set_purchase_orders_opens
  before_action :authenticate_user!
  include ApplicationHelper

  def index
    @accpac_poporh1 = Accpac::Poporh1Datatable
    respond_to do |format|
      format.html
      authorize! :index, @accpac_poporh1,format.json { render json: Accpac::Poporh1Datatable.new(view_context) }
    end
  end

  def drop_shipments
    authorize! :drop_shipments, Accpac::Poporh1
    @drop_shipments = Accpac::Poporh1.find_by_sql("
      SELECT
        POPORH1.PORHSEQ, POPORH1.PONUMBER, POPORH1.VDCODE, POPORH1.VDNAME,
        OEORDH.CUSTOMER, OEORDH.BILNAME, POPORH1.REFERENCE, POPORH1.DESCRIPTIO,
        SUBSTRING(DESCRIPTIO, 1, 8) AS SONUMBER, OEORDH.LOCATION,
        POPORH1.EXPARRIVAL, OEORDH.INVNETWTX
      FROM POPORH1
      JOIN OEORDH ON OEORDH.ORDNUMBER = SUBSTRING(DESCRIPTIO, 1, 8)
      WHERE ISCOMPLETE = 0
      AND DESCRIPTIO LIKE 'SO%'
    ")
  end

  def open_purchase_orders
    authorize! :read, Accpac::Poporh1
    if current_user.type == 'vendor'
      @open_purchase_orders = Views::OpenPurchaseOrder.where(VDCODE: current_user.vendor_id)
    else
      @open_purchase_orders = Views::OpenPurchaseOrder.all
    end
  end

  def show
    authorize! :read, @accpac_poporh1
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def time_line
    render :partial => 'time_line'
  end

  def details
    render :partial => 'details'
  end

  def print
    respond_to do |format|
      format.html {render layout: 'print'}
    end
  end

  private
    def set_accpac_poporh1
      @accpac_poporh1 = Accpac::Poporh1.find(params[:id])
    end

    def set_accpac_poporl
      @accpac_poporl = Accpac::Poporl.select("PORHSEQ", "ITEMNO", "LOCATION", "ITEMDESC")
    end

    def set_purchase_orders_opens
      if current_user.type == "vendor"
        @count = Accpac::Poporh1.open_by_vendor(current_user).count
      else
        @count = Accpac::Poporh1.open.count
      end
    end
end
