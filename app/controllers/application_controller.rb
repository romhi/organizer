class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_filter :set_current_user
  layout :select_by_role
  protect_from_forgery with: :exception
  # layout "admin"

  def set_current_user
    User.current_user = current_user
    yield
  ensure
    # to address the thread variable leak issues in Puma/Thin webserver
    User.current_user = nil
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :first_name, :last_name, :phone, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :full_name, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :age, :phone, :email, :password, :password_confirmation, :current_password) }
  end

  def select_by_role
    current_user.try(:admin) ? "admin" : "application"
  end

end
