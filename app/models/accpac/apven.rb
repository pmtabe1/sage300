# Sagre300 Vendors table.
# Primary key: VENDORID (Vendor Number).
class Accpac::Apven < ActiveRecord::Base
  self.table_name  = 'APVEN'
  self.primary_key = 'VENDORID'

  # Associations with differents tables:
  has_many :icitmv, foreign_key: 'VENDNUM'
  has_many :pohsth, foreign_key: 'VENDOR'
  has_many :pohstl, foreign_key: 'VENDOR'
  has_many :poporh1, foreign_key: 'VDCODE'
  has_many :apobl, foreign_key: 'IDVEND'
  # Association with custom pending payable view.
  has_many :unpaid_payable, foreign_key: 'VENDORID', class_name: "Views::UnpaidPayable"
  # Scope to chek for active vendors.
  scope :active, ->{ where(SWACTV: 1) }

  # This method check for pending purchase orders.
  def open_purchase_order
    self.poporh1.where(ISCOMPLETE: 0)
  end
  
  # Vendor address render async html.
  def address
    "#{self.TEXTSTRE1} #{self.TEXTSTRE2}<br> #{self.NAMECITY}, #{self.CODESTTE} #{self.CODEPSTL}<br> <abbr title='Phone'>P:</abbr> #{helper.number_to_phone(self.TEXTPHON1)}".html_safe
  end

  # This method include helper standard rails number helper.
  # It is used on address method for phone number.
  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

  # Searchkick for Smart Search Using Elasticsearch.
  searchkick index_name: "vendors", callbacks: :async

  def search_data
    {
      vendor_id: Accpac::Apven.find(id).VENDORID,
      vendor_name: Accpac::Apven.find(id).VENDNAME,
      country: Accpac::Apven.find(id).CODECTRY,
      group: Accpac::Apven.find(id).IDGRP
    }
  end
end
