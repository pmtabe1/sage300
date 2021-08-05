class AddPrecentageToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :percentage, :decimal, precision: 19, scale: 2
  end
end
