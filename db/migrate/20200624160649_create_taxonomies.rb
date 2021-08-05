class CreateTaxonomies < ActiveRecord::Migration[5.1]
  def change
    create_table :taxonomies do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
