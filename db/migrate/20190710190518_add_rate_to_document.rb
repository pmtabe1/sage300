class AddRateToDocument < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :rate, :decimal, precision: 19, scale: 6
  end
end
