class HomeController < ApplicationController
  def index
    @plants = Plant.with_attached_images.limit(6)
  end
end
