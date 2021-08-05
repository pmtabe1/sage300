# WidgetQuery associate HABTM widgets and queries.
class WidgetQuery < ActiveRecord::Base
    belongs_to :widget
    belongs_to :query
    #validates :widget_id, presence: true
    #validates :query_id, presence: true
end
