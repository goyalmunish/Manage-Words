require 'spec_helper'

describe "app_settings/edit" do
  before(:each) do
    @app_setting = assign(:app_setting, stub_model(AppSetting,
      :key => "MyString",
      :value => "MyString"
    ))
  end

  it "renders the edit app_setting form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", app_setting_path(@app_setting), "post" do
      assert_select "input#app_setting_key[name=?]", "app_setting[key]"
      assert_select "input#app_setting_value[name=?]", "app_setting[value]"
    end
  end
end
