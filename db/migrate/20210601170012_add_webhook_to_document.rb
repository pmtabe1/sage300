class AddWebhookToDocument < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :webhook, :text
  end
end
