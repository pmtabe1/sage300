class Accpac::ApvenController < ApplicationController
  before_action :set_accpac_apven, only: [:show, :purchase_orders_history, :opened_purchases, :items, :documents]

  def index
    respond_to do |format|
      format.html
      format.json { render json: Accpac::ApvenDatatable.new(view_context) }
    end
  end

  def show
    @item_list = @accpac_apven.icitmv.select("VENDNUM, ITEMNO").group(:ITEMNO, :VENDNUM).order("ITEMNO ASC")
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def purchase_orders_history
    @purchase_orders_history = Accpac::Pohstl.find_by_sql(
      "SELECT POHSTL.ITEMNO, FMTITEMNO, [DESC] AS DESCRIPTION, FISCYEAR, FISCPERIOD, TRANSDATE, TRANSTYPE,
        DOCNUMBER, LOCATION, RQPOSTED, UNIT, FCTOTAL, abc_sales_rank, dense_sales_rank
        FROM POHSTL
        JOIN ICITEM ON POHSTL.ITEMNO = ICITEM.ITEMNO
        LEFT JOIN item_ranks ON POHSTL.ITEMNO = item_ranks.item
        WHERE VENDOR = '#{params[:id]}'")
  end

  def opened_purchases
    @opened_purchases = @accpac_apven.open_purchase_order
  end

  def items
    @items = Accpac::Icitmv.find_by_sql(
      "SELECT ICITMV.ITEMNO, FMTITEMNO, [DESC] AS DESCRIPTION, VENDITEM, VENDTYPE, VENDCOST, VENDCNCY,
        ICITMV.AUDTDATE, ICITMV.AUDTUSER, VENDEXISTS, COSTUNIT, abc_sales_rank, dense_sales_rank
        FROM ICITMV
        JOIN ICITEM ON ICITMV.ITEMNO = ICITEM.ITEMNO
        LEFT JOIN item_ranks ON ICITMV.ITEMNO = item_ranks.item
        WHERE VENDNUM = '#{params[:id]}'")
  end

  def documents
    @documents = @accpac_apven.apobl.order(DATEINVC: :desc)
  end

  def debts
    @dues = Views::UnpaidPayable.all
  end

  private
    def set_accpac_apven
      @accpac_apven = Accpac::Apven.find(params[:id])
    end
end
