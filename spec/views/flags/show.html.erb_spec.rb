require 'spec_helper'

describe "flags/show" do
  before(:each) do
    @flag = assign(:flag, stub_model(Flag,
                                     :name => "Name",
                                     :desc => "Desc"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Desc/)
  end
end
