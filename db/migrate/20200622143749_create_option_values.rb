class CreateOptionValues < ActiveRecord::Migration[5.1]
  def change
    create_table :option_values do |t|
      t.string :name
      t.string :presentation
      t.integer :option_type_id
      t.integer :position

      t.timestamps
    end
  end
end
