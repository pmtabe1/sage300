class CreatePriceAnalysis < ActiveRecord::Migration[5.1]
  def change
    create_table :price_analyses do |t|
      t.string :SALESPER
      t.string :OPTFCAT
      t.integer :N_SALES_12M
      t.decimal :AVG_COST, precision: 19, scale: 2 
      t.decimal :MIN_PRICE, precision: 19, scale: 2 
      t.decimal :MAX_PRICE, precision: 19, scale: 2 
      t.decimal :AVG_PRICE, precision: 19, scale: 2 
      t.decimal :SUGGESTED_PRICE, precision: 19, scale: 2 
      t.decimal :PRICE_DIFFERENCE, precision: 19, scale: 2 
      t.decimal :AVG_QTYSOLD, precision: 19, scale: 2 
      t.decimal :PRED_QTYSOLD, precision: 19, scale: 2 
      t.decimal :ELASTICITY, precision: 19, scale: 2 
      t.decimal :PROFIT_MARGIN, precision: 19, scale: 2 
      t.boolean :BETWEEN_RANGE

      t.timestamps
    end
  end
end
