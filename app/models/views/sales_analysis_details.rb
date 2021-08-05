# This is a detailed scenic view for sales analysis.
module Views
  class SalesAnalysisDetails < ActiveRecord::Base
    # Filterable concerns model applying filters.
    include Filterable

    self.table_name  = 'sales_analysis_details'
    self.primary_key = 'ITEMNO'

    # Filters for sales analysis graphs used on the Chart view.
    scope :item, -> (item) { where ITEMNO: item }
    scope :category, -> (category) { where CATEGORY: category }
    scope :customer, -> (customer) { where IDCUST: customer }
    scope :country, -> (country) { where CODECTRY: country }
    scope :sales_person, -> (sales_person) { where SALESPER: sales_person }
    scope :optfield_category, -> (optfield_category) { where OPTFCAT: optfield_category }
    scope :optfield_product, -> (optfield_product) { where OPTFPROD: optfield_product }
    scope :optfield_type, -> (optfield_type) { where OPTFTYPE: optfield_type }
    scope :start_date, -> (start_date) { where("TRANDATE >= ?", start_date.to_date.strftime("%Y%m%d")) }
    scope :end_date, -> (end_date) { where("TRANDATE <= ?", end_date.to_date.strftime("%Y%m%d")) }
  end
end
