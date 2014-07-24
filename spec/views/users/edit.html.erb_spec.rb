require 'spec_helper'
 
describe "users/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
                                     :first_name => "MyString",
                                     :last_name => "MyString",
                                     :type => "",
                                     :provider => "MyString",
                                     :uid => "MyString",
                                     :additional_info => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_path(@user), "post" do
      assert_select "input#user_first_name[name=?]", "user[first_name]"
      assert_select "input#user_last_name[name=?]", "user[last_name]"
      assert_select "input#user_type[name=?]", "user[type]"
      assert_select "input#user_provider[name=?]", "user[provider]"
      assert_select "input#user_uid[name=?]", "user[uid]"
      assert_select "input#user_additional_info[name=?]", "user[additional_info]"
    end
  end
end
