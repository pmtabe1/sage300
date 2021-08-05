class CreateItemOptionalFields < ActiveRecord::Migration[5.1]
  def change
    create_view :item_optional_fields
  end
end
