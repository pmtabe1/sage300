class CreateAddress < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses, id: false do |t|
      t.string :uniq
      t.string :street
      t.string :city
      t.string :zip
      t.string :state
      t.string :country
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
