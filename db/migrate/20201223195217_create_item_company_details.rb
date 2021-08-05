class CreateItemCompanyDetails < ActiveRecord::Migration[5.1]
  def change
    create_view :item_company_details
  end
end
