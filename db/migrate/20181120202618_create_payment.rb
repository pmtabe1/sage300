class CreatePayment < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.string :uuid
      t.integer :user_id
      t.string :customer
      t.string :customer_name
      t.string :email
      t.decimal :amount, precision: 19, scale: 3

      t.timestamps
    end
  end
end
