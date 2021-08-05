class CreateUnPaidReceivables < ActiveRecord::Migration[5.1]
  def change
    create_view :un_paid_receivables
  end
end
