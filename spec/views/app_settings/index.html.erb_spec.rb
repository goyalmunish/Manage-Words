require 'spec_helper'

describe "app_settings/index" do
  before(:each) do
    assign(:app_settings, [
        stub_model(AppSetting,
                   :key => "Key",
                   :value => "Value"
        ),
        stub_model(AppSetting,
                   :key => "Key",
                   :value => "Value"
        )
    ])
  end

  it "renders a list of app_settings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
