module QueriesHelper
  def run_statement(statement)
    query = "#{statement}"
    ActiveRecord::Base.connection.exec_query(query)
  end

  def query_format_value(key, value)
    if value.is_a?(Numeric) && !key.to_s.end_with?("id") && !key.to_s.start_with?("id")
      number_with_delimiter(value)
    else
      value
    end
  end
end
