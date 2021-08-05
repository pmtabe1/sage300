# Sage300 table Items.
class Accpac::Icitem < ActiveRecord::Base
  self.table_name  = 'ICITEM'
  self.primary_key = 'ITEMNO'

  belongs_to :iccatg, foreign_key: 'CATEGORY'
  has_one :item_rank, foreign_key: 'item', class_name: "Views::ItemRank"

  has_many :iciloc, foreign_key: 'ITEMNO'
  has_many :icloc, :through => :iciloc
  has_many :icitmv, foreign_key: 'ITEMNO'
  has_many :icbomh, foreign_key: 'ITEMNO'
  has_many :icbomd, :through => :icbomh
  has_many :icitemo, foreign_key: 'ITEMNO'
  has_many :icunit, foreign_key: 'ITEMNO'
  has_many :icitmtx, foreign_key: 'ITEMNO'
  has_many :ichist, foreign_key: 'ITEMNO'
  has_many :oeshdt, foreign_key: 'ITEM'
  has_many :pohstl, foreign_key: 'ITEMNO'

  # Duties Optional Fields
  has_one :items_duties, foreign_key: 'ITEMNO', class_name: "Views::ItemsDuties"

  # Association with whole company inventory, coverage in months.
  has_one :coverage, foreign_key: 'ITEMNO', class_name: "Views::ItemCompanyDetail"

  has_many :product_properties, class_name: "ProductProperty", foreign_key: 'itemno'
  has_many :properties, through: :product_properties, class_name: "Property"
  accepts_nested_attributes_for :product_properties, reject_if: lambda { |p| p[:value].blank? }, allow_destroy: true

  # Item association with cart.
  has_many :line_items, foreign_key: 'ITEMNO', class_name: "LineItem"

  #searchkick settings: {index: {max_result_window: 500000}}, text_start: [:ITEMNO]
  searchkick index_name: "items", callbacks: :async

  def search_data
    {
      itemno: Accpac::Icitem.find(id).ITEMNO,
      format_itemno: Accpac::Icitem.find(id).FMTITEMNO,
      description: Accpac::Icitem.find(id).DESC,
      category: Accpac::Icitem.find(id).CATEGORY,
      uom: Accpac::Icitem.find(id).STOCKUNIT
    }
  end

  # Item navigation next.
  def next
    self.class.where("ITEMNO > ?", id).first
  end

  # Item navigation previous.
  def previous
    self.class.where("ITEMNO < ?", id).last
  end

  # Type of labels, this constant is used to generate barcode 
  # labels UPC and GTIN.
  BARCODE = ["UPC", "GTIN"]
end
