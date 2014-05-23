require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :first_name => "First Name",
      :last_name => "Last Name",
      :type => "Type",
      :provider => "Provider",
      :uid => "Uid",
      :additional_info => "Additional Info"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Type/)
    rendered.should match(/Provider/)
    rendered.should match(/Uid/)
    rendered.should match(/Additional Info/)
  end
end
