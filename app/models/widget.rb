# Widget store dinamically metric widgets based on queries using the 
# liquid template language.
class Widget < ActiveRecord::Base
  validates :name, :description, :template, presence: true
  has_many :widget_queries, dependent: :destroy
  has_many :queries, through: :widget_queries

  def to_liquid
    { 
      'query_list' => query_list,
    }
  end

  def query_list
    @result = ActiveRecord::Base.connection.exec_query(queries.map(&:statement).join(""))
    @result.to_hash
  end
end
