class Accpac::OeinvhController < ApplicationController
  before_action :set_accpac_oeinvh, only: [:show, :details, :print]
  before_action :authorize_read_invoice, only: [:show]

  def index
    respond_to do |format|
      format.html
      format.json { render json: Accpac::OeinvhDatatable.new(view_context) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.csv
      format.xls
    end
  end

  def invoice_report
  end

  def results
    @invoices = Accpac::Oeinvh.select("OEINVH.INVUNIQ, OEINVH.INVNUMBER, OEINVH.INVDATE, OEINVH.PONUMBER, OEINVH.CUSTOMER,
      OEINVH.BILNAME, OEINVD.LOCATION, OEINVH.VIADESC, OEINVH.INVFISCPER, OEINVH.INVFISCYR,
      SUM(OEINVD.UNITPRICE * OEINVD.QTYSHIPPED) AS INVAMOUNT, OEINVH.INVMISC").joins(:oeinvd).filter(params.slice(:start_date, :end_date, :loc)).group("
      OEINVH.INVUNIQ, OEINVH.INVNUMBER, OEINVH.INVDATE, OEINVH.PONUMBER, OEINVH.CUSTOMER,
      OEINVH.BILNAME, OEINVD.LOCATION, OEINVH.VIADESC, OEINVH.INVFISCPER, OEINVH.INVFISCYR,OEINVH.INVMISC").order(INVDATE: :desc)
  end

  def print
    render :layout => "print"
  end

  def details
    render :partial => 'details'
  end

  private
    def set_accpac_oeinvh
      if params[:ordnumber]
        @accpac_oeinvh = Accpac::Oeinvh.find(params[:ORDNNUMBER])
      else
        @accpac_oeinvh = Accpac::Oeinvh.find(params[:id])
      end
    end

    def authorize_read_invoice
      @accpac_arcus = Accpac::Arcus.find(@accpac_oeinvh.CUSTOMER)
    end
end
