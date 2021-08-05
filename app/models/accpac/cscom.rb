# Sage300 Company Profile table.
# Primary key: ORGID (Database ID).
#
# We use the company profile to identify the web applciation 
# with the legalname of the Sage300 company. app/helpers/application_helper.rb
class Accpac::Cscom < ActiveRecord::Base
  self.table_name  = 'CSCOM'
  self.primary_key = 'ORGID'

  # Company address rendered as html.
  def address
    "#{self.ADDR01}<br> #{self.CITY}, #{self.STATE} #{self.POSTAL}<br> <abbr title='Phone'>P:</abbr> #{helper.number_to_phone(self.PHONE)}".html_safe
  end

  # This method include helper standard rails number helper.
  # It is used on address method for phone number.
  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end
end
