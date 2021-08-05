module Accpac::OeshdtHelper
  def sales_rep_file
    if current_user.dept_area == "sales"
      #"/json/#{current_user.arsap.squish}.json"
      "https://s3.amazonaws.com/erp-accpac/json/sales_#{company_id}_#{current_user.arsap.squish}.json"
    else
      #"/json/sales_analysis_#{company_id}.json"
      #"https://s3.amazonaws.com/erp-accpac/json/sales_analysis_#{company_id}.json"
      "https://s3.amazonaws.com/erp-accpac/json/sales_#{company_id}.json"
    end
  end
end
