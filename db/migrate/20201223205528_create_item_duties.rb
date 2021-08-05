class CreateItemDuties < ActiveRecord::Migration[5.1]
  def change
    create_view :item_duties
  end
end
