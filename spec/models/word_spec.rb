require 'spec_helper'

describe Word do
  subject { build(:word) }
  it "strips string fields before validation" do
    word1 = Word.new(:word => '    new  ', :trick => ' some trick ')
    word2 = Word.new(word1.attributes)
    word1.valid?
    word1[:word].should_not == word2[:word]
    word1[:trick].should_not == word2[:trick]
    word1[:word].should == word2[:word].strip
    word1[:trick].should == word2[:trick].strip
  end
  it "nullifies blank values" do
    word1 = Word.new(:word => '    new  ', :trick => ' some trick ', :additional_info => '      ')
    word1.valid?
    word1[:additional_info].should be_nil
  end
end

