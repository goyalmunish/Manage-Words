require 'spec_helper'

module FeatureHelper
  def log_in(email, password)
    visit new_user_session_path
    within('#new_user') do
      fill_in 'user_email', :with => email
      fill_in 'user_password', :with => password
    end
    click_on 'Sign in'
  end
end
