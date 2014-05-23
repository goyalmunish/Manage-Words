require 'spec_helper'

describe "app_settings/new" do
  before(:each) do
    assign(:app_setting, stub_model(AppSetting,
      :key => "MyString",
      :value => "MyString"
    ).as_new_record)
  end

  it "renders new app_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", app_settings_path, "post" do
      assert_select "input#app_setting_key[name=?]", "app_setting[key]"
      assert_select "input#app_setting_value[name=?]", "app_setting[value]"
    end
  end
end
