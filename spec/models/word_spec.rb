require 'spec_helper'

describe Word do
  # DEFINING SUBJECT EXPLICITLY
  # DEFINING HELPER METHODS
  # BEFORE EACH HOOK
  # CALLING SHARED EXAMPLES
  # DIFFERENT CONTEXTS
    # BEFORE EACH HOOK
    # CALLING SHARED EXAMPLES
    # EXAMPLES
  # DIRECT EXAMPLES

  context 'Testing Validations' do
    it { should validate_presence_of(:user_id)}
    it { should validate_presence_of(:word)}
    it { should validate_uniqueness_of(:word).scoped_to(:user_id)}
    it { should ensure_length_of(:word).is_at_most(25) }
    it { should ensure_length_of(:trick).is_at_most(100) }
    it { should ensure_length_of(:additional_info).is_at_most(2048) }
  end

  describe ".search" do
    before(:each) do
      @u = create(:user)
      @w1 = create(:word_without_user, user: @u, word: 'abc1')
      @w2 = create(:word_without_user, user: @u, word: 'abc2')
      @w3 = create(:word_without_user, user: @u, word: '1abc')
      @w4 = create(:word_without_user, user: @u, word: '2abc')
      @w5 = create(:word_without_user, user: @u, word: '1abc1')
      @w6 = create(:word_without_user, user: @u, word: '2abc2')
      @w7 = create(:word_without_user, user: @u, word: 'xyz1', trick: 'XabcX', additional_info: '')
      @w8 = create(:word_without_user, user: @u, word: 'xyz2', trick: 'XX XX', additional_info: 'XabcX')
      @w9 = create(:word_without_user, user: @u, word: 'xyz3', trick: 'XX X', additional_info: 'X X X')
      # ap User.all
      # ap Word.all
    end
    context "if database is 'pg'" do
      it "searches for words starting with 'abc'" do
        expect(Word.search(database: 'pg', search_type: 'word', search_text: '^abc').count).to be 2
      end
      it "searches for words ending with 'abc'" do
        expect(Word.search(database: 'pg', search_type: 'word', search_text: 'abc$').count).to be 2
      end
      it "searches for words containing 'abc'" do
        expect(Word.search(database: 'pg', search_type: 'word', search_text: 'abc').count).to be 6
      end
      it "searches records (FULL TEXT) for string 'abc'" do
        expect(Word.search(database: 'pg', search_type: 'record', search_text: 'abc').count).to be 8
      end
      it "searches for words containing 'abc' with default search_type" do
        expect(Word.search(database: 'pg', search_text: 'abc').count).to be 6
      end
      it "searches for words containing 'abc' with search_negative" do
        expect(Word.search(database: 'pg', search_text: 'abc', search_negative: true).count).to be 3
      end
      it "searches records (FULL TEXT) containing 'abc' with search_negative" do
        expect(Word.search(database: 'pg', search_type: 'record', search_text: 'abc', search_negative: true).count).to be 1
      end
    end
    context "if database is NOT 'pg'" do
      it "searches for words containing 'abc'" do
        expect(Word.search(database: 'mysql', search_type: 'word', search_text: 'abc').count).to be 6
      end
      it "searches records (FULL TEXT) for string 'abc'" do
        expect(Word.search(database: 'mysql', search_type: 'record', search_text: 'abc').count).to be 8
      end
      it "searches for words containing 'abc' with search_negative" do
        expect(Word.search(database: 'mysql', search_type: 'word', search_text: 'abc', search_negative: true).count).to be 3
      end
      it "searches records (FULL TEXT) for string 'abc' with search_negative" do
        expect(Word.search(database: 'mysql', search_type: 'record', search_text: 'abc', search_negative: true).count).to be 1
      end
    end
    it "returns all records with search_text as nil" do
      expect(Word.search(database: 'pg', search_type: 'record', search_text: nil, search_negative: true).count).to be 9
    end
    it "returns all records with search_text as blank" do
      expect(Word.search(database: 'mysql', search_type: 'record', search_text: ' ', search_negative: true).count).to be 9
    end
  end

  describe ".limit_records" do
    before(:each) do
      @u = create(:user)
      @w1 = create(:word_without_user, user: @u, word: 'abc1')
      @w2 = create(:word_without_user, user: @u, word: 'abc2')
      @w3 = create(:word_without_user, user: @u, word: '1abc')
      @w4 = create(:word_without_user, user: @u, word: '2abc')
      @w5 = create(:word_without_user, user: @u, word: '1abc1')
      @w6 = create(:word_without_user, user: @u, word: '2abc2')
      @w7 = create(:word_without_user, user: @u, word: 'xyz1', trick: 'XabcX', additional_info: '')
      @w8 = create(:word_without_user, user: @u, word: 'xyz2', trick: 'XX XX', additional_info: 'XabcX')
      @w9 = create(:word_without_user, user: @u, word: 'xyz3', trick: 'XX X', additional_info: 'X X X')
      # ap User.all
      # ap Word.all
    end
    context "common use cases irrespective of collection type" do
      it "passes the collection as it is if record_limit is blank" do
        collection = double(:collection)
        expect(Word.limit_records(:collection => collection, :record_limit => nil)).to eq(collection)
      end
    end
    context "if passed collection is Array" do
      it "returns first N number of records" do
        collection = [@w1, @w2, @w3, @w4, @w5, @w6, @w7, @w8, @w9]
        expect(Word.limit_records(:collection => collection, :record_limit => 0).count).to be 0
        expect(Word.limit_records(:collection => collection, :record_limit => 3).count).to be 3
        expect(Word.limit_records(:collection => collection, :record_limit => 9).count).to be 9
      end
      it "automatically converts 'record_limit' to integer" do
        collection = [@w1, @w2, @w3, @w4, @w5, @w6, @w7, @w8, @w9]
        expect(Word.limit_records(:collection => collection, :record_limit => '3').count).to be 3
      end
    end
    context "if passed collection is ActiveRecord Word class" do
      it "returns first N number of records" do
        collection = Word
        expect(Word.limit_records(:collection => collection, :record_limit => 0).count).to be 0
        expect(Word.limit_records(:collection => collection, :record_limit => 3).count).to be 3
        expect(Word.limit_records(:collection => collection, :record_limit => 9).count).to be 9
      end
      it "automatically converts 'record_limit' to integer" do
        collection = Word
        expect(Word.limit_records(:collection => collection, :record_limit => '3').count).to be 3
      end
    end
    context "if passed collection is ActiveRelation of words" do
      it "returns first N number of records" do
        collection = @u.words
        expect(Word.limit_records(:collection => collection, :record_limit => 0).count).to be 0
        expect(Word.limit_records(:collection => collection, :record_limit => 3).count).to be 3
        expect(Word.limit_records(:collection => collection, :record_limit => 9).count).to be 9
      end
      it "automatically converts 'record_limit' to integer" do
        collection = @u.words
        expect(Word.limit_records(:collection => collection, :record_limit => '3').count).to be 3
      end
    end
  end

  describe ".number_of_flag_associations" do
    before(:each) do
      @u = create(:user)
      @w1 = create(:word_without_user, user: @u, word: 'abc1')
      @w2 = create(:word_without_user, user: @u, word: 'abc2')
      @w3 = create(:word_without_user, user: @u, word: '1abc')
      @flag_cl_1 = create(:flag_cl_1)
      @flag_cl_2 = create(:flag_cl_2)
      @flag_cp_1 = create(:flag_cp_1)
      @flag_cp_0 = create(:flag_cp_0)
      @flag_k_0 = create(:flag_k_0)
      @flag_k_1 = create(:flag_k_1)
      @w1.flags << @flag_cl_1; @w1.flags << @flag_cp_1; @w1.flags << @flag_k_0
      @w2.flags << @flag_cl_2; @w2.flags << @flag_cp_0
    end
    context "on single word" do
      it "works on word with 3 flags" do
        expect(Word.number_of_flag_associations(@w1)).to be 3
      end
      it "works on word with 2 flags" do
        expect(Word.number_of_flag_associations(@w2)).to be 2
      end
      it "works on word with 0 flags" do
        expect(Word.number_of_flag_associations(@w3)).to be 0
      end
    end
    context "on an array of words" do
      it "works on array of 3 words" do
        expect(Word.number_of_flag_associations([@w1, @w2, @w3])).to be 5
      end
    end
    context "on an association of words" do
      it "works on Word association contaning 3 words" do
        expect(Word.number_of_flag_associations(@u.words)).to be 5
      end
    end
    context "passed collection is different form Word::ActiveRecord_Associations_CollectionProxy, Word::ActiveRecord_Relation, Word::ActiveRecord_AssociationRelation, Array, Word" do
      it "raises error for instance of Hash as argument" do
        expect{Word.number_of_flag_associations(instance_of(Hash))}.to raise_error
      end
    end
  end

  describe "#promote_flag" do
    before(:each) do
      @flag_cl_0 = create(:flag_cl_0)
      @flag_cl_2 = create(:flag_cl_2)
      @flag_cl_4 = create(:flag_cl_4)
    end
    context "for dir='up'" do
      it "for flag_value and with non-highest possible flag_value for that flag_name, assigns flag with same name but with next higer level" do
        # Note: good test case for reference (in learning)
        word = create(:word)
        word.flags << @flag_cl_0
        indices = {:current_flag_id => @flag_cl_0.id, :next_flag_id => @flag_cl_2.id}
        allow(Flag).to receive(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => 0, :dir => 'up').and_return(indices)
        word.promote_flag(:flag_name => 'CL', :dir => 'up')
        expect(Flag).to have_received(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => 0, :dir => 'up')
        expect(word.flag_ids).to include(@flag_cl_2.id)
        expect(word.flag_ids).to_not include(@flag_cl_0.id)
      end
      it "for nil flag_value, assigns flag of same name with lowest level" do
        word = create(:word)
        indices = {:current_flag_id => nil, :next_flag_id => @flag_cl_0.id}
        allow(Flag).to receive(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => nil, :dir => 'up').and_return(indices)
        word.promote_flag(:flag_name => 'CL', :dir => 'up')
        expect(Flag).to have_received(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => nil, :dir => 'up')
        expect(word.flag_ids).to include(@flag_cl_0.id)
      end
      it "for highest possible flag_value for that flag_name, flag remains unchanged" do
        word = create(:word)
        word.flags << @flag_cl_4
        indices = {:current_flag_id => @flag_cl_4.id, :next_flag_id => @flag_cl_4.id}
        allow(Flag).to receive(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => 4, :dir => 'up').and_return(indices)
        word.promote_flag(:flag_name => 'CL', :dir => 'up')
        expect(Flag).to have_received(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => 4, :dir => 'up')
        expect(word.flag_ids).to include(@flag_cl_4.id)
      end
    end
    context "for dir='down'" do
      it "for flag_value and with non-lowest possible flag_value for that flag_name, assigns flag with samae name but with next lower level" do
        word = create(:word)
        word.flags << @flag_cl_2
        indices = {:current_flag_id => @flag_cl_2.id, :next_flag_id => @flag_cl_0.id}
        allow(Flag).to receive(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => 2, :dir => 'down').and_return(indices)
        word.promote_flag(:flag_name => 'CL', :dir => 'down')
        expect(Flag).to have_received(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => 2, :dir => 'down')
        expect(word.flag_ids).to include(@flag_cl_0.id)
        expect(word.flag_ids).to_not include(@flag_cl_2.id)
      end
      it "for nil flag_value, assigns nothing" do
        word = create(:word)
        indices = {:current_flag_id => nil, :next_flag_id => nil}
        allow(Flag).to receive(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => nil, :dir => 'down').and_return(indices)
        word.promote_flag(:flag_name => 'CL', :dir => 'down')
        expect(Flag).to have_received(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => nil, :dir => 'down')
        expect(word.flag_ids).to_not include(@flag_cl_0.id)
        expect(word.flag_ids).to_not include(@flag_cl_2.id)
        expect(word.flag_ids).to_not include(@flag_cl_4.id)
      end
      it "for lowest possible flag_value for that flag_name, flag remains unchanged" do
        word = create(:word)
        word.flags << @flag_cl_0
        indices = {:current_flag_id => @flag_cl_0.id, :next_flag_id => @flag_cl_0.id}
        allow(Flag).to receive(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => 0, :dir => 'down').and_return(indices)
        word.promote_flag(:flag_name => 'CL', :dir => 'down')
        expect(Flag).to have_received(:current_and_next_flag_id_for_flag_name_value_dir).with(:name => 'CL', :value => 0, :dir => 'down')
        expect(word.flag_ids).to include(@flag_cl_0.id)
      end
    end
  end

  context "Tests relevant for only developer" do
    context 'Testing Associations' do
      # Associations are structures, they shouldn't be tested
      it { should belong_to(:user)}
      it { should have_many(:flags_words)}
      it { should have_many(:flags).through(:flags_words)}
    end
    context 'Testing Callbacks' do
      it "strips string fields before validation" do
        word1 = Word.new(:word => '    new  ', :trick => ' some trick ')
        word2 = Word.new(word1.attributes)
        word1.valid?
        expect(word1[:word]).to_not eq(word2[:word])
        expect(word1[:trick]).to_not eq(word2[:trick])
        expect(word1[:word]).to eq(word2[:word].strip)
        expect(word1[:trick]).to eq(word2[:trick].strip)
      end
      it "nullifies blank values before validations" do
        word1 = Word.new(:word => '    new  ', :trick => ' some trick ', :additional_info => '      ')
        word1.valid?
        expect(word1[:additional_info]).to be_nil
      end
      it "before_validation -> calls '#convert_blank_to_nil'" do
        word = build(:word)
        expect(word).to receive(:convert_blank_to_nil)
        word.valid?
      end
      it "before_validation -> calls '#strip_string_fields'" do
        word = build(:word)
        expect(word).to receive(:strip_string_fields)
        word.valid?
      end
      it "before_validation -> no more calls '#down_case_word'" do
        # Note: good test case for reference (in learning)
        # Note: "When to use doubles?": while testing a particular method, we should be testing only its responsibility and not what it expects from PUBLIC METHODS, so any custom method that it calls should be mocked
        # Note: for "Message Expectations" on real or stubbed method, and there are two patterns to achieve it: "Message Expectation Pattern" and "Test Spies Pattern"
        # Note: here we are using "Message Expectation Pattern" on real object for real method
        # Note: "Message Expectations" can be on real or stubbed method (using 'receive' or 'have_received')
        # Note: on a double object, if you expect receiving of a method (using 'receive' or 'have_received'), you don't have to (but you can, and I do for understanding) stub that method explicitly
        # Note: a real or mock method both can register how many times they were called
        # Note: for test cases within same context, first you should write positive and general test cases and then the boundary conditions based test cases
        word = build(:word) # Note: word is real object, not double
        expect(word).not_to receive(:down_case_word)  # Note: raising expectation to receive this method anytime before example ends
        word.valid?
      end
      it "after_save -> calls '#remove_similar_flags_with_lower_level'" do
        # Note: good test case for reference (in learning)
        # Note: here we are using "Test Spies Pattern" on a stubbed method
        # Note: here we are stubbing the method and confirming that it is called at a specific point
        word = build(:word)
        allow(word).to receive(:remove_similar_flags_with_lower_level)  # Note: Here we are stubbing a real object with (mock) method (so that real method won't be called). Now 'word' register the number of times it receives
        # Note: if you stub a real object with a (mock) method, then its real method won't be called
        expect(word).to_not have_received(:remove_similar_flags_with_lower_level)
        word.save
        expect(word).to have_received(:remove_similar_flags_with_lower_level)
      end
      it "#remove_similar_flags_with_lower_level" do
        # Note: good test case for reference (in learning)
        word = create(:word)
        ids = double('ids').as_null_object  # Note: now it is allowed to receive any message but won't register anything it receives
        allow(word).to receive(:flags)  # Noe: now it is stubbed with 'flags' message
        expect(Flag).to receive(:flag_ids_with_available_max_level).with(word.flags).and_return(ids).ordered
        expect(word).to receive(:flag_ids=).with(ids).ordered # Note: here we are expecting 'flag_ids=' not 'flag_ids'
        word.send(:remove_similar_flags_with_lower_level) # Note: in order to test private/protected methods, you can call them using 'send' method
      end
      it "#flag_value_for_flag_name" do
        word = create(:word)
        flag_cl_2 = create(:flag_cl_2)
        flag_cp_1 = create(:flag_cp_1)
        word.flags << flag_cl_2; word.flags << flag_cp_1
        expect(word.send(:flag_value_for_flag_name, 'CL')).to eq(2)
        expect(word.send(:flag_value_for_flag_name, 'CP')).to eq(1)
      end
    end
  end
end

