require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:users, [
        stub_model(User,
                   :first_name => "First Name",
                   :last_name => "Last Name",
                   :type => "Type",
                   :provider => "Provider",
                   :uid => "Uid",
                   :additional_info => "Additional Info"
        ),
        stub_model(User,
                   :first_name => "First Name",
                   :last_name => "Last Name",
                   :type => "Type",
                   :provider => "Provider",
                   :uid => "Uid",
                   :additional_info => "Additional Info"
        )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Provider".to_s, :count => 2
    assert_select "tr>td", :text => "Uid".to_s, :count => 2
    assert_select "tr>td", :text => "Additional Info".to_s, :count => 2
  end
end
