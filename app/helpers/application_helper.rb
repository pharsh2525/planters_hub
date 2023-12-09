module ApplicationHelper
  def plant_search_query
    @plant_search_query ||= Plant.ransack(params[:q])
  end
end
