# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:checkout]
  before_action :load_cart, only: [:show, :checkout]

  def show
    # The @cart_items variable is now available for the view to display
  end

  def add
    # Find the plant we're adding
    plant = Plant.find(params[:plant_id])

    # Load the cart from the session, or initialize it if it doesn't exist yet
    cart = session[:cart] || []

    # Check if the plant is already in the cart
    item = cart.find { |i| i["plant_id"] == plant.id }

    if item
      # If the item is already in the cart, increase the quantity
      item["quantity"] += params[:quantity].to_i
    else
      # If the item is not in the cart, add it with the specified quantity
      cart << { "plant_id" => plant.id, "quantity" => params[:quantity].to_i }
    end

    # Save the updated cart back into the session
    session[:cart] = cart

    # Redirect to the cart show path with a success message
    redirect_to cart_path, notice: 'Item added to cart.'
  end

  def remove
    # Simulate finding the item in the array
    item_index = current_cart.find_index { |item| item["plant_id"] == params[:plant_id].to_i }
    if item_index.nil?
      flash[:alert] = "Item could not be found."
    else
      # Remove the item from the array
      current_cart.delete_at(item_index)
      flash[:notice] = "Item removed successfully."
    end

    # Update the session or where the cart is stored
    session[:cart] = current_cart

    # Redirect to the cart show page
    redirect_to cart_path
  end

  def update_quantity
    item = current_cart.find { |i| i["plant_id"] == params[:plant_id].to_i }
    if item
      item["quantity"] += params[:change] == 'increase' ? 1 : -1
      item["quantity"] = [item["quantity"], 1].max # Ensure quantity doesn't go below 1
      session[:cart] = current_cart # Save the updated cart back to the session
    end
    redirect_to cart_path # Redirect back to the cart page
  end


  def clear
    # Clear the cart
    session[:cart] = []
    redirect_to cart_path, notice: 'Cart cleared.'
  end

  def checkout
    # Redirect to sign-in page if the user is not logged in
    Order.transaction do
      order = current_user.orders.create!(total: calculate_total_price, status: 'pending')
      @cart_items.each do |item|
        order.order_items.create!(plant_id: item[:plant].id, quantity: item[:quantity], price: item[:plant].price)
      end
      session[:cart] = [] # Clear the cart after successful order creation
      redirect_to order_success_path(order), notice: 'Thank you for your order.'
    rescue ActiveRecord::RecordInvalid => e
      redirect_to cart_path, alert: "There was an error processing your order: #{e.message}"
    end

    # Placeholder for actual checkout logic
    # This is where you'd typically handle payment and order creation
  end

  private

  def load_cart
    @cart_items = session[:cart] || []
    # Convert session cart item data into actual Plant instances
    @cart_items = @cart_items.map do |item|
      plant = Plant.find(item["plant_id"])
      { plant: plant, quantity: item["quantity"] }
    end
  end

  def calculate_total_price
    # This method will calculate the total price of all items in the cart
    @cart_items.sum { |item| item[:plant].price * item[:quantity] }
  end
end
