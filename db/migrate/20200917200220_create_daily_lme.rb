class CreateDailyLme < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_lme do |t|
      t.decimal :lme, precision: 19, scale: 2
      t.decimal :smm, precision: 19, scale: 2
      t.decimal :rate, precision: 19, scale: 6
      t.decimal :oanda, precision: 19, scale: 6

      t.timestamps
    end
  end
end
