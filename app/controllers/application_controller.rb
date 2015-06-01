class ApplicationController < ActionController::Base
  # I want to run below code only in case of production
  if %w(production).include? Rails.env
    rescue_from Exception do |ex|
      # displaying error
      flash[:alert] = 'Error: ' + ex.message
      redirect_to display_error_path
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # handling any left unhandled exception
  protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session

  acts_as_token_authentication_handler_for User
  before_filter :authenticate_user!

  # instance methods
  def admin_only
    unless current_user.type == Admin.to_s
      raise 'RequireAdminPrivileges'
    end
  end

end
