class CreateWidgetQueries < ActiveRecord::Migration[5.1]
  def change
    create_table :widget_queries do |t|
      t.integer :widget_id
      t.integer :query_id
      t.integer :position
    end
  end
end
