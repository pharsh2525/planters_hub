# app/controllers/payment_methods_controller.rb
class PaymentMethodsController < ApplicationController
  before_action :set_stripe_customer, only: [:new, :create]

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

      redirect_to success_path, notice: 'Payment method added successfully.'
    rescue Stripe::StripeError => e
      redirect_to new_payment_method_path, alert: e.message
    end
  end

  private

  def set_stripe_customer
    # Retrieve or create a Stripe customer for the current user
    @stripe_customer = current_user.stripe_customer
  end
end
