class Documents < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.integer :document_type_id
      t.integer :created_by
      t.integer :submitted_by
      t.timestamp :submitted_at
      t.integer :approved_by
      t.json :properties_column
      t.text :document_id
      t.text :purchase_orders

      t.timestamps

      # Columns to delete no longer in use
      t.text :properties
      t.string :uuid
      t.boolean :status
      t.boolean :confirmed
      t.timestamp :confirmed_at

      # Attachment columns
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.timestamp :file_updated_at
    end
  end
end
