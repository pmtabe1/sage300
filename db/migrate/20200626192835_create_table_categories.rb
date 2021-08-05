class CreateTableCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.string :permalink
      t.string :meta_title
      t.string :meta_description
      t.string :meta_keywords
      t.string :ancestry

      t.timestamps
    end

    add_index :categories, :ancestry
  end
end
