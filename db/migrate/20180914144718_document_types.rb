class DocumentTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :document_types do |t|
      t.string :name
      t.string :slug
      t.json :preferences
      t.timestamps
    end
    add_index :document_types, :slug
  end
end
