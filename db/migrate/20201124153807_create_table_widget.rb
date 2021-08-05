class CreateTableWidget < ActiveRecord::Migration[5.1]
  def change
    create_table :widgets do |t|
      t.integer :user_id
      t.string :name
      t.string :description
      t.text :template

      t.timestamps
    end
  end
end
