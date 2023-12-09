# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order.order_items.includes(plant: { images_attachments: :blob })
  end

  # Add other CRUD actions as needed...

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
