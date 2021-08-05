class CreateOnHandPivot < ActiveRecord::Migration[5.1]
  def change
    create_view :on_hand_pivot
  end
end
