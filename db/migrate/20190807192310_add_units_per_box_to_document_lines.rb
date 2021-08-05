class AddUnitsPerBoxToDocumentLines < ActiveRecord::Migration[5.1]
  def change
    add_column :document_lines, :units_per_box, :string
  end
end
