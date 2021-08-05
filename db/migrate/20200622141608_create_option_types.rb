class CreateOptionTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :option_types do |t|
      t.string :name
      t.string :presentation
      t.integer :position

      t.timestamps
    end
  end
end
