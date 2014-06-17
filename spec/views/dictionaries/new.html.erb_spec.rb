require 'spec_helper'

describe "dictionaries/new" do
  before(:each) do
    assign(:dictionary, stub_model(Dictionary,
                                   :name => "MyString",
                                   :url => "MyString",
                                   :separator => "MyString",
                                   :suffix => "MyString",
                                   :additional_info => "MyString"
    ).as_new_record)
  end

  it "renders new dictionary form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", dictionaries_path, "post" do
      assert_select "input#dictionary_name[name=?]", "dictionary[name]"
      assert_select "input#dictionary_url[name=?]", "dictionary[url]"
      assert_select "input#dictionary_separator[name=?]", "dictionary[separator]"
      assert_select "input#dictionary_suffix[name=?]", "dictionary[suffix]"
      assert_select "input#dictionary_additional_info[name=?]", "dictionary[additional_info]"
    end
  end
end
