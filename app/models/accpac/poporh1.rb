# Sage300 table Purchase Orders Headers
class Accpac::Poporh1 < ActiveRecord::Base
  self.table_name  = 'POPORH1'
  self.primary_key = 'PORHSEQ'

  # Association with Purchase Orders Header2, Purchase Order Lines, Vendors and Document Lines.
  # # Document Line is the custom model use along with Document to track our supply chain.
  has_one :poporh2, foreign_key: 'PORHSEQ'
  has_many :poporl, foreign_key: 'PORHSEQ'
  has_many :document_line, foreign_key: 'porhseq', class_name: 'DocumentLine'
  belongs_to :apven, foreign_key: 'VDCODE'

  # Scopes to filter Purchasse Orders.
  scope :open, ->{ where("ISCOMPLETE = ? AND PONUMBER LIKE ?", 0, "PO%") }
  scope :open_by_vendor, lambda { |user| where("ISCOMPLETE = ? AND VDCODE = ?", 0, user.vendor_id) }
  scope :by_vendor, lambda { |user| where(VDCODE: user.vendor_id) }

  # Method to combine location code and description.
  def po_ship_to_loc
    "#{self.poporh2.STCODE} - #{self.poporh2.STDESC}"
  end

  # Method to combine Purchase Order address.
  def po_ship_to_addr
    "#{self.poporh2.STADDRESS1} #{self.poporh2.STADDRESS2}"
  end

  # Method to combine city, state and zipcode.
  def po_ship_to_city
    "#{self.poporh2.STCITY} #{self.poporh2.STSTATE} #{self.poporh2.STZIP}"
  end
end
