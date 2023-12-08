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
    setup_checkout_data
  end

  def update_address
    load_cart
    @subtotal = calculate_subtotal
    update_taxes(params[:address_id])

    respond_to do |format|
      format.json {
        render json: {
          pst_amount: @pst_amount,
          gst_amount: @gst_amount,
          hst_amount: @hst_amount,
        }
      }
    end
  end


  def place_order
    payment_method_id = params[:payment_method_id]
    total_amount = calculate_total_price

    begin
      process_payment(payment_method_id, total_amount)
      create_order(total_amount)
      session[:cart] = [] # Clear the cart
      redirect_to success_path, notice: 'Order successfully placed.'
    rescue Stripe::StripeError => e
      redirect_to cart_checkout_path, alert: e.message
    end
  end

  private

  def load_cart
    session_cart = session[:cart] || []
    @cart_items = session_cart.map do |item|
      plant = Plant.find(item["plant_id"])
      { plant: plant, quantity: item["quantity"] }
    end
  end

  def calculate_subtotal
    @subtotal = @cart_items.sum { |item| item[:plant].price * item[:quantity] }
  end

  def setup_checkout_data
    @user_addresses = current_user.addresses
    @subtotal = calculate_subtotal
    @pst_amount, @gst_amount, @hst_amount = 0, 0, 0
    fetch_payment_methods
  end

  def update_taxes(address_id)
    selected_address = Address.find(address_id)
    tax_rates = fetch_tax_rates(selected_address.province_id)
    apply_taxes(tax_rates)
  end

  def fetch_tax_rates(province_id)
    province = Province.find(province_id)
    { pst: province.PST || 0, gst: province.GST || 0, hst: province.HST || 0 }
  end

  def apply_taxes(tax_rates)
    @pst_amount = @subtotal * tax_rates[:pst]
    @gst_amount = @subtotal * tax_rates[:gst]
    @hst_amount = @subtotal * tax_rates[:hst]
  end

  def fetch_payment_methods
    if current_user.stripe_customer_id
      @payment_methods = Stripe::PaymentMethod.list(customer: current_user.stripe_customer_id, type: 'card')
    end
  end

  def process_payment(payment_method_id, total_amount)
    Stripe::PaymentIntent.create(amount: total_amount, currency: 'usd', payment_method: payment_method_id, confirm: true)
  end

  def create_order(total_amount)
    order = current_user.orders.create!(total: total_amount, status: 'completed')
    @cart_items.each do |item|
      order.order_items.create!(plant_id: item[:plant].id, quantity: item[:quantity], unit_price: item[:plant].price)
    end
  end

  def convert_cart_items
    @cart_items = @cart_items.map do |item|
      plant = Plant.find(item["plant_id"])
      { plant: plant, quantity: item["quantity"] }
    end
  end

end
