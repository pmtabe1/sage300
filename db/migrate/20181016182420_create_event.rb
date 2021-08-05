class CreateEvent < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start
      t.datetime :end
      t.string :color

      # Columns used to relate events with other models
      t.string :event_type
      t.text :event_id

      t.timestamps
    end
  end
end
