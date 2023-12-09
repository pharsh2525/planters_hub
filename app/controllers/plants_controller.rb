class PlantsController < ApplicationController
  def index
    @plants = Plant.order('created_at DESC').page(params[:page]).per(12)
  end

  def show
    @plant = Plant.find(params[:id])
  end
end
