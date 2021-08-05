class AddActionToClaims < ActiveRecord::Migration[5.1]
  def change
    add_column :claims, :action, :string
  end
end
