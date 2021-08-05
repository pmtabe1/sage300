class Accpac::OeshdtController < ApplicationController

  def sales_analysis
    authorize! :sales_analysis, Accpac::Oeshdt
  end

  def graphs
    respond_to do |format|
      format.html
      format.js
    end
  end

  def filter_form
    render :partial => "form"
  end
end
