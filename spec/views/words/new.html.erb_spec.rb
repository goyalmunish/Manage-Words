require 'spec_helper'

describe "words/new" do
  before(:each) do
    assign(:word, stub_model(Word,
                             :word => "MyString",
                             :trick => "MyString",
                             :additional_info => "MyString"
    ).as_new_record)
  end

  it "renders new word form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", words_path, "post" do
      assert_select "input#word_word[name=?]", "word[word]"
      assert_select "input#word_trick[name=?]", "word[trick]"
      assert_select "input#word_additional_info[name=?]", "word[additional_info]"
    end
  end
end
