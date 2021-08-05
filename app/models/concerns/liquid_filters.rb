module LiquidFilters
  include ActionView::Helpers::NumberHelper
  
  def currency(netsales)
    number_to_currency(netsales, precision: 0)
  end
end

