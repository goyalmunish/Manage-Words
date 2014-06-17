require 'spec_helper'

describe "dictionaries/show" do
  before(:each) do
    @dictionary = assign(:dictionary, stub_model(Dictionary,
                                                 :name => "Name",
                                                 :url => "Url",
                                                 :separator => "Separator",
                                                 :suffix => "Suffix",
                                                 :additional_info => "Additional Info"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Url/)
    rendered.should match(/Separator/)
    rendered.should match(/Suffix/)
    rendered.should match(/Additional Info/)
  end
end
