# Sage300 table Purcahse Orders Header2
class Accpac::Poporh2 < ActiveRecord::Base
  self.table_name  = 'POPORH2'
  self.primary_key = 'PORHSEQ'

  # Association with Purchase Orders and Purchase Order Lines.
  belongs_to :poporh1, foreign_key: 'PORHSEQ'
  has_many :poporl, foreign_key: 'PORHSEQ'

  # Purcahse Order address rendered as html.
  def address
    "<strong>#{self.STCODE} - #{self.STDESC}<strong><br> #{self.STADDRESS1}, #{self.STADDRESS2}<br> #{self.STCITY}, #{self.STSTATE}, #{self.STCOUNTRY}<br> <abbr title='Phone'>P:</abbr> #{helper.number_to_phone(self.STPHONE)}".html_safe
  end

  #This method include helper standard rails number helper. It is used on address method for phone number.
  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end
end
