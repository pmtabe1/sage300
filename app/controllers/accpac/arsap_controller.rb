class Accpac::ArsapController < ApplicationController
  before_action :set_accpac_arsap, only: [:show, :sales_history, :customers]
  include ApplicationHelper

  def index
    @accpac_arsap = Accpac::ArsapDatatable
    respond_to do |format|
      format.html
      authorize! :index, @accpac_arsap, format.json { render json: Accpac::ArsapDatatable.new(view_context) }
    end
  end

  def sales_history
    authorize! :read, @accpac_arsap
    @sales_history = Accpac::Oeshdt.find_by_sql(
      "SELECT ITEM, [DESC] AS DESCRIPTION, ORDNUMBER, CUSTOMER, NAMECUST, PONUMBER, OESHDT.LOCATION, YR, PERIOD, QTYSOLD, FAMTSALES
        FROM OESHDT
        JOIN ICITEM ON OESHDT.ITEM = ICITEM.ITEMNO
        JOIN ARCUS ON OESHDT.CUSTOMER = ARCUS.IDCUST
        WHERE SALESPER = '#{@accpac_arsap}'")
  end

  def customers
    @customers = Accpac::Arcus.select(:IDCUST, :NAMECUST, :IDGRP, :CODETERR, :DATESTART, :CODECTRY, :CODETERM, :AMTBALDUEH, :OVERAMT).by_sales_rep(@accpac_arsap)
  end

  def show
    authorize! :read, @accpac_arsap
  end

  private
    def set_accpac_arsap
      @accpac_arsap = Accpac::Arsap.find(params[:id])
    end
end
