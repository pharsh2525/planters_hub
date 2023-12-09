class PlantsController < ApplicationController
  def index
    if params[:q].present?
      # Initialize the Ransack search object only when search parameters are present
      @q = Plant.ransack(params[:q])
      @plants = @q.result(distinct: true)
    else
      # If no search parameters, just load all plants
      @plants = Plant.all
    end

    @plants = @plants.page(params[:page]).per(12)
    # Load categories for the category filter dropdown
    @categories = Category.all
  end

  def show
    @plant = Plant.find(params[:id])
  end
end
