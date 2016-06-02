class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  around_filter :set_current_user

  protect_from_forgery with: :exception
  # layout "admin"

  def set_current_user
    User.current_user = current_user
    yield
  ensure
    # to address the thread variable leak issues in Puma/Thin webserver
    User.current_user = nil
  end


end
