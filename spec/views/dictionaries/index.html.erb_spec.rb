require 'spec_helper'

describe "dictionaries/index" do
  before(:each) do
    assign(:dictionaries, [
      stub_model(Dictionary,
        :name => "Name",
        :url => "Url",
        :separator => "Separator",
        :suffix => "Suffix",
        :additional_info => "Additional Info"
      ),
      stub_model(Dictionary,
        :name => "Name",
        :url => "Url",
        :separator => "Separator",
        :suffix => "Suffix",
        :additional_info => "Additional Info"
      )
    ])
  end

  it "renders a list of dictionaries" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Separator".to_s, :count => 2
    assert_select "tr>td", :text => "Suffix".to_s, :count => 2
    assert_select "tr>td", :text => "Additional Info".to_s, :count => 2
  end
end
