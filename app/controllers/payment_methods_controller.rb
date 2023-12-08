# app/controllers/payment_methods_controller.rb
class PaymentMethodsController < ApplicationController
  before_action :set_stripe_customer, only: [:new, :create]

  def index
    @payment_methods = Stripe::PaymentMethod.list(
      customer: current_user.stripe_customer_id,
      type: 'card'
    )
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to root_path
  end

  def new
    # Display form for new payment method
  end

  def create
    begin
      payment_method = Stripe::PaymentMethod.attach(
        params[:payment_method_id],
        { customer:  current_user.stripe_customer.id}
      )

      # Set the default payment method for the customer
      @stripe_customer.invoice_settings.default_payment_method = payment_method.id
      @stripe_customer.save

      redirect_to payment_methods_path, notice: 'Payment method added successfully.'
    rescue Stripe::StripeError => e
      redirect_to new_payment_methods_path, alert: e.message
    end
  end

  def destroy
    payment_method = Stripe::PaymentMethod.retrieve(params[:id])
    payment_method.detach

    # Add any other logic you need here, such as removing references to the payment method in your database

    redirect_to payment_methods_path, notice: 'Payment method removed successfully.'
  rescue Stripe::StripeError => e
    redirect_to payment_methods_path, alert: e.message
  end


  private

  def set_stripe_customer
    # Retrieve or create a Stripe customer for the current user
    @stripe_customer = current_user.stripe_customer
  end
end
