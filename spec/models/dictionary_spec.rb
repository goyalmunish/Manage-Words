require 'spec_helper'

describe Dictionary do
  context "Testing Validations" do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:url)}
    it { should validate_presence_of(:separator)}
    it { should validate_uniqueness_of(:name)}
    it { should ensure_length_of(:name).is_at_most(25) }
    it { should ensure_length_of(:url).is_at_most(150) }
    it { should ensure_length_of(:separator).is_at_most(5) }
    it { should ensure_length_of(:suffix).is_at_most(25) }
    it { should ensure_length_of(:additional_info).is_at_most(250) }
  end
  describe "#url_for_phrase" do
    it "works with 1 word phrase" do
      dictionary = create(:dictionary, :url => 'url', :separator => '-', :suffix => 'suffix')
      phrase = 'word'
      expect(dictionary.url_for_phrase(phrase)).to eq("urlwordsuffix")
    end
    it "works with 2 word phrase" do
      dictionary = create(:dictionary, :url => 'url', :separator => '-', :suffix => 'suffix')
      phrase = 'my word'
      expect(dictionary.url_for_phrase(phrase)).to eq("urlmy-wordsuffix")
    end
  end
  describe "#humanized_name" do
    it "for name 'dictionary', it returns 'Dictionary'" do
      dictionary = create(:dictionary, :name => "dictionary")
      expect(dictionary.humanized_name).to eq('Dictionary')
    end
    it "for name 'dictionary_dot_com', it returns 'Dictionary Dot Com'" do
      dictionary = create(:dictionary, :name => "dictionary_dot_com")
      expect(dictionary.humanized_name).to eq('Dictionary Dot Com')
    end
    it "for name 'dictionary dot com', it returns 'Dictionary Dot Com'" do
      dictionary = create(:dictionary, :name => "dictionary dot com")
      expect(dictionary.humanized_name).to eq('Dictionary Dot Com')
    end
  end
  context "Tests relevant for only developer" do
    context 'Testing Associations' do
      # Associations are structures, they shouldn't be tested
      it { should have_many(:dictionaries_users)}
      it { should have_many(:users).through(:dictionaries_users)}
    end
    context 'Testing Callbacks' do
      it "before_validation -> calls '#convert_blank_to_nil'" do
        dictionary = build(:dictionary)
        expect(dictionary).to receive(:convert_blank_to_nil)
        dictionary.valid?
      end
      it "before_validation -> calls '#strip_string_fields'" do
        dictionary = build(:dictionary)
        expect(dictionary).to receive(:strip_string_fields)
        dictionary.valid?
      end
    end
  end
end
