require 'spec_helper'

describe WordDataElement do
  before(:each) do
    @wde = WordDataElement.new(word: 'my_word',
                               trick: 'some trick',
                               additional_info: 'some additional info',
                               flags_attributes: [{name: 'CL', value: 1}, {name: 'CP', value: 1}])
  end
  context 'Testing Validations' do
    # nothing
  end
  describe "#to_h" do
    it "description: converts word_data_element to hash representation" do
      expect(@wde.to_h).to eq({:word => @wde.word, :trick => @wde.trick, :additional_info => @wde.additional_info, :flags_attributes => @wde.flags_attributes})
    end
  end
  describe "#append_to_flags_attributes(args)" do
    it "description: adds 'name' and 'value' from passed hash as argument to current word_data_element instance's flags_attributes array" do
      flag_count = @wde.flags_attributes.count
      @wde.append_to_flags_attributes({a: 'hi', name: 'added_name', b: 'hi', value: 'added_value'})
      expect(@wde.flags_attributes[flag_count]).to eq({name: 'added_name', value: 'added_value'})
    end
    it "works for WordDataElement instance initialized without flags_attributes" do
      @wde = WordDataElement.new(word: 'my_word', trick: 'some trick', additional_info: 'some additional info')
      flag_count = @wde.flags_attributes.count
      @wde.append_to_flags_attributes({a: 'hi', name: 'added_name', b: 'hi', value: 'added_value'})
      expect(@wde.flags_attributes[flag_count]).to eq({name: 'added_name', value: 'added_value'})
    end
    it "works for WordDataElement instance initialized with flags_attributes set to empty array" do
      @wde = WordDataElement.new(word: 'my_word', trick: 'some trick', additional_info: 'some additional info', flags_attributes: Array.new)
      flag_count = @wde.flags_attributes.count
      @wde.append_to_flags_attributes({a: 'hi', name: 'added_name', b: 'hi', value: 'added_value'})
      expect(@wde.flags_attributes[flag_count]).to eq({name: 'added_name', value: 'added_value'})
    end
  end
  describe "Backup Functionality for a Single User" do
    before(:each) do
      # Note: here real objects are used instead of mocks, as I found using real object to be easier here
      user = create(:user)
      word1 = create(:word, user: user, word: 'word1')
      word2 = create(:word, user: user, word: 'word2')
      create(:word, user: user, word: 'word3')
      flag1 = create(:flag, name: 'CL', value: 1)
      flag2 = create(:flag, name: 'CP', value: 2)
      flag3 = create(:flag, name: 'K', value: 3)
      word1.flags << flag1; word1.flags << flag2
      word2.flags << flag3
      @words = user.words.includes(:flags)
    end
    describe ".word_data_backup(words)" do
      it "works with association containing 3 words and eagar loaded flags" do
        backup_data = WordDataElement.word_data_backup(@words)
        expect(backup_data.count).to be 3
        expect(backup_data[0].keys).to include(:word, :trick, :additional_info, :flags_attributes)
        expect(backup_data[1].keys).to include(:word, :trick, :additional_info, :flags_attributes)
        expect(backup_data[2].keys).to include(:word, :trick, :additional_info, :flags_attributes)
        expect(backup_data[0][:flags_attributes].count).to be 2
        expect(backup_data[1][:flags_attributes].count).to be 1
        expect(backup_data[2][:flags_attributes].count).to be 0
      end
      it "works with default value" do
        backup_data = WordDataElement.word_data_backup()
        expect(backup_data.count).to be 3
        expect(backup_data[0].keys).to include(:word, :trick, :additional_info, :flags_attributes)
        expect(backup_data[1].keys).to include(:word, :trick, :additional_info, :flags_attributes)
        expect(backup_data[2].keys).to include(:word, :trick, :additional_info, :flags_attributes)
        expect(backup_data[0][:flags_attributes].count).to be 2
        expect(backup_data[1][:flags_attributes].count).to be 1
        expect(backup_data[2][:flags_attributes].count).to be 0
      end
    end
    describe ".restore_word_data_backup(:user => test_user@word_list.com, :array_data => backup_data)" do
      it "works with backup data containing 3 words and associated flag_attributes" do
        backup_data = WordDataElement.word_data_backup(@words)
        User.destroy_all
        Word.destroy_all
        user = create(:user, :email => 'test_user@word_list.com')
        WordDataElement.restore_word_data_backup(:user => user, :array_data => backup_data)
        expect(Word.all.size).to be 3
        expect(Word.where(:word => 'word1').first.flags.count).to be 2
        expect(Word.where(:word => 'word2').first.flags.count).to be 1
        expect(Word.where(:word => 'word3').first.flags.count).to be 0
      end
      it "does not overwrite a word (and its associated flags), if it already exists" do
        backup_data = WordDataElement.word_data_backup(@words)
        Word.destroy_all
        User.destroy_all
        user = create(:user, :email => 'test_user@word_list.com')
        create(:word, user: user, word: 'word1')
        WordDataElement.restore_word_data_backup(:user => user, :array_data => backup_data)
        expect(Word.all.size).to be 3
        expect(Word.where(:word => 'word1').first.flags.count).to be 0
      end
    end
  end

  context "Tests relevant for only developer" do
    context 'Testing Associations' do
    end
    context 'Testing Callbacks' do
    end
  end
end
