class AddIsDefaultImageToVariants < ActiveRecord::Migration[5.1]
  def change
    add_column :variants, :is_default_image, :boolean
  end
end
