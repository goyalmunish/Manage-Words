require 'spec_helper'

describe "flags/edit" do
  before(:each) do
    @flag = assign(:flag, stub_model(Flag,
                                     :name => "MyString",
                                     :desc => "MyString"
    ))
  end

  it "renders the edit flag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", flag_path(@flag), "post" do
      assert_select "input#flag_name[name=?]", "flag[name]"
      assert_select "input#flag_desc[name=?]", "flag[desc]"
    end
  end
end
