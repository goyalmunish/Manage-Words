require 'spec_helper'

describe "app_settings/show" do
  before(:each) do
    @app_setting = assign(:app_setting, stub_model(AppSetting,
                                                   :key => "Key",
                                                   :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Key/)
    rendered.should match(/Value/)
  end
end
