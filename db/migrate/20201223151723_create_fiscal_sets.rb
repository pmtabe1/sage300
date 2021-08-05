class CreateFiscalSets < ActiveRecord::Migration[5.1]
  def change
    create_view :fiscal_sets
  end
end
