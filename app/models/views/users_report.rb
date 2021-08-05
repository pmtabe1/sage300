# Scenic view to report orders processes by users ordered by dates.
module Views
  class UsersReport < ActiveRecord::Base
    # Filterable concerns model applying filters.
    include Filterable

    self.table_name  = 'order_report_users'
    self.primary_key = 'ENTEREDBY'

    # Scopes to filter with Filterable class
    scope :start_date, -> (start_date) { where("ORDDATE >= ?", start_date.to_date.strftime("%Y-%m-%d")) }
    scope :end_date, -> (end_date) { where("ORDDATE <= ?", end_date.to_date.strftime("%Y-%m-%d")) }
    scope :entered_by, -> (entered_by) { where ENTEREDBY: entered_by }
  end
end
