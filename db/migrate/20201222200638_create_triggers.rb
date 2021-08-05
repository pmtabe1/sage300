class CreateTriggers < ActiveRecord::Migration[5.1]
  def change
    create_view :triggers
  end
end
