class CreateAttachment < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.integer :attachable_id
      t.string :attachable_type
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.timestamp :file_updated_at
    end
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
