require 'spec_helper'

describe "words/index" do
  before(:each) do
    assign(:words, [
      stub_model(Word,
        :word => "Word",
        :trick => "Trick",
        :additional_info => "Additional Info"
      ),
      stub_model(Word,
        :word => "Word",
        :trick => "Trick",
        :additional_info => "Additional Info"
      )
    ])
  end

  it "renders a list of words" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Word".to_s, :count => 2
    assert_select "tr>td", :text => "Trick".to_s, :count => 2
    assert_select "tr>td", :text => "Additional Info".to_s, :count => 2
  end
end
