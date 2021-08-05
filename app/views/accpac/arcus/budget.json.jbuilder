json.array! @budget do |budget|
  json.category budget.category
  json.category_description budget.category_description
  json.year budget.year
  json.current_year_netsales budget.current_year_netsales.to_f
  json.ytd_budget budget.ytd_budget.to_f
  json.difference budget.difference.to_f
  json.current_year_budget budget.current_year_budget.to_f
end
