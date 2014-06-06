class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # handling any left unhandled exception

  # I want to run below code only in case of production
  if Rails.env == 'production'
    rescue_from Exception do |ex|
      # displaying error
      flash[:alert] = 'Error: ' + ex.message
      redirect_to display_error_path
    end
  end

  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  # instance methods
  def admin_only
    unless current_user.type == Admin.to_s
      raise 'RequireAdminPrivileges'
    end
  end

end
