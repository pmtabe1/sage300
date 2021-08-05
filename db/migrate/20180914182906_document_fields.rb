class DocumentFields < ActiveRecord::Migration[5.1]
  def change
    create_table :document_fields do |t|
      t.string :name
      t.string :field_type
      t.boolean :required
      t.belongs_to :document_type, index: true
      t.timestamps
    end
  end
end
