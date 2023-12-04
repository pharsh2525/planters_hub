class AccountController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @orders = current_user.orders if current_user.orders
    @addresses = current_user.addresses if current_user.addresses
    # Add more user-specific information as needed
  end
end
