class CreateUnPaidPayables < ActiveRecord::Migration[5.1]
  def change
    create_view :un_paid_payables
  end
end
