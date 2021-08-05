class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :user_id, foreign_key: true
      t.boolean :complete
      t.timestamp :completed_at

      t.timestamps
    end
  end
end
