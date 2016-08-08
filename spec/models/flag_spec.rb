require 'spec_helper'

describe Flag do
  context 'Testing Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:value) }
    it { should validate_length_of(:name).is_at_most(5) }
    it { should validate_length_of(:desc).is_at_most(100) }
    it { 
      # Note that "munish".to_i == 0, so even if you pass a sting that doesn't look an integer, that will pass
      # should validate_numericality_of(:value)
    }
    it {
      # Refer: https://github.com/thoughtbot/shoulda-matchers/issues/884
      subject.value = 2
      unless subject.name
        subject.name = "flag"
      end
      should validate_uniqueness_of(:name).scoped_to(:value)
    }
  end

  it ".flag_ids_with_available_max_level" do
    flags = Array.new
    flag_cl_1 = create(:flag_cl_1)
    flag_cl_2 = create(:flag_cl_2)
    flag_cp_1 = create(:flag_cp_1)
    flag_cp_0 = create(:flag_cp_0)
    flag_k_0 = create(:flag_k_0)
    flag_k_1 = create(:flag_k_1)
    flags << flag_cl_1; flags << flag_cl_2; flags << flag_cp_1; flags << flag_cp_0; flags << flag_k_0; flags << flag_k_1;
    # original_id_array = [flag_cl_1.id, flag_cl_2.id, flag_cp_1.id, flag_cp_0.id, flag_k_0.id, flag_k_1.id].sort
    expected_id_array = [flag_cl_2.id, flag_cp_1.id, flag_k_1.id].sort
    expect(Flag.flag_ids_with_available_max_level.sort).to eq(expected_id_array)
  end

  describe ".current_and_next_flag_id_for_flag_name_value_dir" do
    before(:each) do
      @flag_cl_0 = create(:flag_cl_0)
      @flag_cl_2 = create(:flag_cl_2)
      @flag_cl_4 = create(:flag_cl_4)
    end
    context "for dir='up'" do
      it "for flag_value and with non-highest possible flag_value for that flag_name, current_flag_id gives flag_id for currently associated flag and next_flag_id gives flag_id of flag with same name but with next higer level" do
        return_value = Flag.current_and_next_flag_id_for_flag_name_value_dir(:dir => 'up', :name => 'CL', :value => 0)
        expected_value = {:current_flag_id => @flag_cl_0.id, :next_flag_id => @flag_cl_2.id}
        expect(return_value).to eq(expected_value)
      end
      it "for nil flag_value, current_flag_id is nil and next_flag_id corresponds to flag of same name with lowest level" do
        return_value = Flag.current_and_next_flag_id_for_flag_name_value_dir(:dir => 'up', :name => 'CL', :value => nil)
        expected_value = {:current_flag_id => nil, :next_flag_id => @flag_cl_0.id}
        expect(return_value).to eq(expected_value)
      end
      it "for highest possible flag_value for that flag_name, next_flag_id will be same as current_flag_id" do
        return_value = Flag.current_and_next_flag_id_for_flag_name_value_dir(:dir => 'up', :name => 'CL', :value => 4)
        expected_value = {:current_flag_id => @flag_cl_4.id, :next_flag_id => @flag_cl_4.id}
        expect(return_value).to eq(expected_value)
      end
      it "for non-existing flag name, raises error" do
        expect{Flag.current_and_next_flag_id_for_flag_name_value_dir(:dir => 'up', :name => 'incorrect-value', :value => 1000)}.to raise_error
      end
      it "for non-existing flag with given name and value pair, raises error" do
        expect{Flag.current_and_next_flag_id_for_flag_name_value_dir(:dir => 'up', :name => 'CL', :value => 1000)}.to raise_error
      end
      it "for value of dir other than 'up' and 'down', raises error" do
        expect{Flag.current_and_next_flag_id_for_flag_name_value_dir(:dir => 'incorrect-value', :name => 'CL', :value => 0)}.to raise_error
      end
    end
    context "for dir='down'" do
      it "for flag_value and with non-lowest possible flag_value for that flag_name, current flag_id gives flag_id for currently associated flag and next_flag_id gives flag_id fo flag with samae name but with next lower level" do
        return_value = Flag.current_and_next_flag_id_for_flag_name_value_dir(:dir => 'down', :name => 'CL', :value => 2)
        expected_value = {:current_flag_id => @flag_cl_2.id, :next_flag_id => @flag_cl_0.id}
        expect(return_value).to eq(expected_value)
      end
      it "for nil flag_value, current_flag_id and next_flag_id will be nil" do
        return_value = Flag.current_and_next_flag_id_for_flag_name_value_dir(:dir => 'down', :name => 'CL', :value => nil)
        expected_value = {:current_flag_id => nil, :next_flag_id => nil}
        expect(return_value).to eq(expected_value)
      end
      it "for lowest possible flag_value for that flag_name, next_flag_id will be same as current_flag_id" do
        return_value = Flag.current_and_next_flag_id_for_flag_name_value_dir(:dir => 'down', :name => 'CL', :value => 0)
        expected_value = {:current_flag_id => @flag_cl_0.id, :next_flag_id => @flag_cl_0.id}
        expect(return_value).to eq(expected_value)
      end
    end
  end

  describe "#flag_name_and_value" do
    it "returns CL-7 for flag with 'CL' as name and 7 as value" do
      @flag1 = create(:flag, :name => 'CL', :value => 7)
      expect(@flag1.flag_name_and_value).to eq('CL-7')
    end
    it "returns K-0 for flag with 'K' as name and 0 as value" do
      @flag2 = create(:flag, :name => 'K', :value => 0)
      expect(@flag2.flag_name_and_value).to eq('K-0')
    end
  end

  context "Tests relevant for only developer" do
    context 'Testing Associations' do
      it { should have_many(:flags_words)}
      it { should have_many(:words).through(:flags_words)}
    end
    context 'Testing Callbacks' do
      it "before_validation -> calls '#convert_blank_to_nil'" do
        flag = build(:flag)
        expect(flag).to receive(:convert_blank_to_nil)
        flag.valid?
      end
      it "before_validation -> calls '#strip_string_fields'" do
        flag = build(:flag)
        expect(flag).to receive(:strip_string_fields)
        flag.valid?
      end
    end
  end
end
