class CreateItemsLocationDetails < ActiveRecord::Migration[5.1]
  def change
    create_view :items_location_details
  end
end
