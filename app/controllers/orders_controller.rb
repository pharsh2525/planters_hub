# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
  end

  # Add other CRUD actions as needed...

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
