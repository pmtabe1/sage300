module Accpac::PohstlHelper
  def purchases_analysis_json_file
    #"/json/purchases_analysis.json"
    "https://s3.amazonaws.com/erp-accpac/json/purchases_analysis_#{company_id}.json"
  end
end
