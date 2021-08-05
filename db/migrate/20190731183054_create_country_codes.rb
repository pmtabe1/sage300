class CreateCountryCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :country_codes, id: false do |t|
      t.integer :code
      t.string :name
      t.string :iso_code
    end

    add_index :country_codes, :code
    add_index :country_codes, :iso_code
  end
end
