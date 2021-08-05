class AddRateFieldsToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :rate_date, :date
    add_column :documents, :rate_type, :string
  end
end
