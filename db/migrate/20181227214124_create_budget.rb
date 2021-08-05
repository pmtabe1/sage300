class CreateBudget < ActiveRecord::Migration[5.1]
  def change
    create_table :budgets do |t|
      t.string :salesperson
      t.string :customer
      t.string :customer_name
      t.string :category
      t.string :category_description
      t.string :user_id
      t.string :year
      t.decimal :amount, precision: 19, scale: 4
      t.text :comments

      t.timestamps
    end
  end
end
