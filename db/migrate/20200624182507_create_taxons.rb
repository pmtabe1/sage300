class CreateTaxons < ActiveRecord::Migration[5.1]
  def change
    create_table :taxons do |t|
      t.integer :parent_id
      t.integer :position
      t.string :name
      t.text :description
      t.string :permalink
      t.integer :taxonomy_id
      t.integer :lft
      t.integer :rgt
      t.string :meta_title
      t.string :meta_description
      t.string :meta_keywords
      t.integer :depth

      t.timestamps
    end
  end
end
