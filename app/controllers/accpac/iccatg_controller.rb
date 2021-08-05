class Accpac::IccatgController < ApplicationController
  before_action :set_accpac_iccatg, only: [:show]

  def index
    respond_to do |format|
      format.html
      format.json { render json: Accpac::IccatgDatatable.new(view_context) }
    end
  end

  def show
    @items = Accpac::Iccatg.find_by_sql(
      "SELECT c.CATEGORY, c.[DESC], i.ITEMNO, i.FMTITEMNO, i.[DESC], i.STOCKUNIT,
        i.COMMENT1 AS PACKUNIT, i.COMMENT4 AS PROPERTIES, l.[LOCATION], l.QTYONHAND,
        l.QTYCOMMIT, (l.QTYONHAND - l.QTYCOMMIT) AS QTYAVAILAB,
        l.QTYSALORDR, l.QTYONORDER, l.RECENTCOST,
        ((l.QTYONHAND - l.QTYCOMMIT)*l.RECENTCOST) AS AMOUNT,
        r.abc_sales_rank, r.dense_sales_rank
      FROM ICCATG c
      JOIN ICITEM i ON c.CATEGORY = i.CATEGORY
      JOIN ICILOC l ON i.ITEMNO = l.ITEMNO
      LEFT JOIN ItemsRankingLocation r ON r.item = i.ITEMNO AND r.[location] = l.[LOCATION]
      WHERE c.CATEGORY = '#{params[:id]}'
      ORDER BY i.ITEMNO ASC"
    )
  end

  private
    def set_accpac_iccatg
      @accpac_iccatg = Accpac::Iccatg.find(params[:id])
    end
end
