class CreateQueries < ActiveRecord::Migration[5.1]
  def change
    create_table :queries do |t|
      t.integer :user_id
      t.string :name
      t.string :description
      t.text :statement

      t.timestamps
    end
  end
end
