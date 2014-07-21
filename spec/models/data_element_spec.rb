require 'spec_helper'

describe DataElement do
  before(:each) do
    @words_data = [
        {word: 'my_word1',
         trick: 'some trick1',
         additional_info: 'some additional info',
         flags_attributes: [{name: 'CL', value: 1}, {name: 'CP', value: 1}]},
        {word: 'my_word2',
         trick: 'some trick2',
         additional_info: 'some additional info',
         flags_attributes: [{name: 'CL', value: 2}, {name: 'CP', value: 2}]}]
    @de = DataElement.new(:email => 'test_user@word_list.com', :words => @words_data)
  end
  context 'Testing Validations' do
    # nothing
  end
  describe '#to_h' do
    it "description: converts data_element to hash representation" do
      expect(@de.to_h).to eq({:email => @de.email, :words => @de.words})
    end
  end
  describe '#append_to_words(word_data_element)' do
    it 'description: appends passed WordDataElement to "words" attribute of current instance' do
      @wde = WordDataElement.new(word: 'my_word',
                                 trick: 'some trick',
                                 additional_info: 'some additional info',
                                 flags_attributes: [{name: 'CL', value: 1}, {name: 'CP', value: 1}])
      expect{@de.append_to_words(@wde)}.to change {@de.words.count}.from(2).to(3)
    end
  end
  describe "Backup Functionality for a Multiple Users" do
    before(:each) do
      # Note: here real objects are used instead of mocks, as I found using real object to be easier here
      user1 = create(:user, :email => 'user1@word_list.com')
      user2 = create(:user, :email => 'user2@word_list.com')
      word1 = create(:word, user: user1, word: 'word1')
      word2 = create(:word, user: user1, word: 'word2')
      word3 = create(:word, user: user1, word: 'word3')
      word4 = create(:word, user: user2, word: 'word1')
      flag1 = create(:flag, name: 'CL', value: 1)
      flag2 = create(:flag, name: 'CP', value: 2)
      flag3 = create(:flag, name: 'K', value: 3)
      word1.flags << flag1; word1.flags << flag2
      word2.flags << flag3
      @users = User.includes(:words => :flags).where(:email => [user1.email, user2.email])
    end
    describe '.data_backup(users)' do
      it "works with association containing 2 users and eagar loaded words and flags" do
        backup_data = DataElement.data_backup(@users)
        expect(backup_data.count).to be 2
        expect(backup_data[0][:words].count).to be 3
        expect(backup_data[1][:words].count).to be 1
      end
      it "works with default_value" do
        backup_data = DataElement.data_backup()
        expect(backup_data.count).to be 2
        expect(backup_data[0][:words].count).to be 3
        expect(backup_data[1][:words].count).to be 1
      end
    end
    describe '.restore_data_backup(array_data)' do
      it "works with backup data containing 2 users and associated words and flag_attributes" do
        backup_data = DataElement.data_backup(@users)
        Word.destroy_all
        User.destroy_all
        user1 = create(:user, :email => 'user1@word_list.com')
        user2 = create(:user, :email => 'user2@word_list.com')
        DataElement.restore_data_backup(backup_data)
        expect(user1.words.count).to be 3
        expect(user2.words.count).to be 1
        expect(user1.words.first.flags.count).to be 2
      end
    end
  end
  context 'Tests relevant for only developer' do
    context 'Testing Associations' do
    end
    context 'Testing Callbacks' do
    end
  end
end

