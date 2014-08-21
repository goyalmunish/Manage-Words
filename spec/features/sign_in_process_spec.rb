require 'spec_helper'

describe "the signin process",:type => :feature do
  before(:each) do
    @user = create(:user, :password => 'password', :password_confirmation => 'password')
  end
  context "with correct credentials" do
    it "signs me in" do
      visit '/users/sign_in'
      within('#new_user') do
        fill_in 'user_email', :with => @user.email
        fill_in 'user_password', :with => 'password'
      end
      click_on 'Sign in'
      expect(page).to have_content(@user.email)
      # page.save_screenshot('tmp/login_success.png')
    end
  end
  context "with incorrect credentials" do
    it "displays 'Invalid email or password' error" do
      visit '/users/sign_in'
      within('#new_user') do
        fill_in 'user_email', :with => @user.email
        fill_in 'user_password', :with => 'wrong_password'
      end
      click_on 'Sign in'
      expect(page).to have_content('Invalid email or password')
      # page.save_screenshot('tmp/login_failure.png')
    end
  end
end
