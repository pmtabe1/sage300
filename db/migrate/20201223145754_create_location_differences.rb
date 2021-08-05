class CreateLocationDifferences < ActiveRecord::Migration[5.1]
  def change
    create_view :location_differences
  end
end
