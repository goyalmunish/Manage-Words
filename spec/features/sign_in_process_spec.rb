require 'spec_helper'

describe "the signin process",:type => :feature do
  before(:each) do
    @user = create(:user, :password => 'password', :password_confirmation => 'password')
  end
  context "with application in log-out state" do
    context "it redirects all valid URLs that require authentication to /users/sign_in" do
      it "checked with /words" do
        visit words_path
        expect(current_path).to eq(new_user_session_path)
      end
      it "checked with /flags" do
        visit flags_path
        expect(current_path).to eq(new_user_session_path)
      end
      it "checked with /dictionaries" do
        visit dictionaries_path
        expect(current_path).to eq(new_user_session_path)
      end
    end
    context "it displays pages for all valid URLs that doesn't require authentication" do
      it "checked with /site_home/help" do
        visit site_home_help_path
        expect(current_path).to eq(site_home_help_path)
      end
      it "checked with /site_help/contact_us" do
        visit site_home_contact_us_path
        expect(current_path).to eq(site_home_contact_us_path)
      end
      it "checked with /site_help/about_us" do
        visit site_home_about_us_path
        expect(current_path).to eq(site_home_about_us_path)
      end
    end
    context "with correct credentials at /users/sign_in" do
      it "signs me in" do
        log_in(@user.email, 'password')
        expect(page).to have_content(@user.email)
        expect(current_path).to eq(root_path)
        # page.save_screenshot('tmp/login_success.png')
      end
    end
    context "with incorrect credentials at /users/sign_in" do
      it "displays 'Invalid email or password' error" do
        log_in(@user.email, 'wrong_password')
        expect(page).to have_content('Invalid email or password')
        expect(current_path).to eq(new_user_session_path)
        # page.save_screenshot('tmp/login_failure.png')
      end
    end
  end
end
