require 'spec_helper'

describe "flags/new" do
  before(:each) do
    assign(:flag, stub_model(Flag,
                             :name => "MyString",
                             :desc => "MyString"
    ).as_new_record)
  end

  it "renders new flag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", flags_path, "post" do
      assert_select "input#flag_name[name=?]", "flag[name]"
      assert_select "input#flag_desc[name=?]", "flag[desc]"
    end
  end
end
