class CreateFulfillments < ActiveRecord::Migration[5.1]
  def change
    create_view :fulfillments
  end
end
