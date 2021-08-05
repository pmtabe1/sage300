class Charts::TransfersController < ApplicationController
  def daily
    transfer_from_date = params[:from_date]
    transfer_to_date = params[:to_date]
    if params[:from_date].present?
      render json: Accpac::Ictreh.where(TRANSDATE: transfer_from_date.to_date.strftime("%Y%m%d")..transfer_to_date.to_date.strftime("%Y%m%d")).group("CONVERT(DATE, CAST(TRANSDATE AS VARCHAR(8)), 112)").count
    else
      render json: Accpac::Ictreh.where(TRANSDATE: 30.days.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d")).group("CONVERT(DATE, CAST(TRANSDATE AS VARCHAR(8)), 112)").count
    end
  end

  def by_location
    render json: Accpac::Ictreh.joins(:ictred).where(TRANSDATE: 30.days.ago.strftime("%Y%m%d")..Time.now.strftime("%Y%m%d")).group(:FROMLOC).count
  end
end
