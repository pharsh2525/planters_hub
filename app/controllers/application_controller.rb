class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  helper_method :current_cart

  private

  def current_cart
    session[:cart] ||= []
  end

  def after_sign_in_path_for(resource)
    session[:return_to] || root_path
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.is_admin?
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end
end
