class SiteHomeController < ApplicationController

  skip_before_filter :authenticate_user!

  def home
  end

  def sign_up
  end

  def sign_in
  end

  def contact_us
  end

  def about_us
  end

  def faqs
  end

  def help
  end
end
