class CreateBudgetAnalyses < ActiveRecord::Migration[5.1]
  def change
    create_view :budget_analyses
  end
end
