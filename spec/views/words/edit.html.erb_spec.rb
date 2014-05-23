require 'spec_helper'

describe "words/edit" do
  before(:each) do
    @word = assign(:word, stub_model(Word,
      :word => "MyString",
      :trick => "MyString",
      :additional_info => "MyString"
    ))
  end

  it "renders the edit word form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", word_path(@word), "post" do
      assert_select "input#word_word[name=?]", "word[word]"
      assert_select "input#word_trick[name=?]", "word[trick]"
      assert_select "input#word_additional_info[name=?]", "word[additional_info]"
    end
  end
end
