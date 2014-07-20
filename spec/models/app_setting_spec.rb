require 'spec_helper'

describe AppSetting do
  context 'Testing Validation' do 
    it { should validate_presence_of(:key)}
  end
  describe '.find_by_key(k)' do
    it "finds record with existing key" do
      app_setting1 = create(:app_setting, :key => 'MyKey1', :value => 'do_not_find_it')
      app_setting = create(:app_setting, :key => 'MyKey', :value => 'find_it')
      app_setting2 = create(:app_setting, :key => 'MyKey2', :value => 'do_not_find_it')
      record = AppSetting.find_by_key('my_key')
      expect(record.key).to eq('my_key')
      expect(record.value).to eq('find_it')
    end
    it "returns nil for non-existing key" do
      app_setting = create(:app_setting, :key => 'MyKey', :value => 'find_it')
      record = AppSetting.find_by_key('non-existing-key')
      expect(record).to be_nil
    end
  end
  describe '.get(k)' do
    it "finds value of existing key" do
      app_setting = double('app_setting', :value => 'some_value')
      allow(AppSetting).to receive('find_by_key').with('my_key').and_return(app_setting)
      expect(AppSetting).to receive('find_by_key').with('my_key')
      expect(AppSetting.get('my_key')).to eq('some_value')
    end
    it "returns nil value for non-existing key" do
      app_setting = nil
      allow(AppSetting).to receive('find_by_key').with('my_key').and_return(app_setting)
      expect(AppSetting).to receive('find_by_key').with('my_key')
      expect(AppSetting.get('my_key')).to be_nil
    end
    it "raises error if key is blank" do
      expect {AppSetting.get('  ')}.to raise_error(RuntimeError, 'NonBlankKeyRequired') # Note: for expecting error ,we used curly braces
    end
  end
  describe '.set(k, v)' do
    it "sets value of an existing key and returns record" do
      app_setting = create(:app_setting, :key => 'my_key', :value => 'some_value')
      allow(AppSetting).to receive(:find_by_key).with('my_key').and_return(app_setting)
      expect(AppSetting).to receive(:find_by_key).with('my_key')
      return_value = AppSetting.set('my_key', 'some_value')
      expect(app_setting.value).to eq('some_value')
      expect(return_value.value).to eq('some_value')
    end
    it "creates record, sets value of a non-existing key, and returns record" do
      allow(AppSetting).to receive(:find_by_key).with('my_key').and_return(nil)
      return_value = AppSetting.set('my_key', 'some_value')
      expect(return_value.value).to eq('some_value')
    end
    it "raises error is key is blank" do
      expect {AppSetting.set('  ', 'some_value')}.to raise_error(RuntimeError, 'NonBlankKeyRequired')
    end
  end
  describe '.set_if_nil(k, v)' do
    it "for given key, with an existing record with nil value or a non-existing record, it sets its value to given value" do
      allow(AppSetting).to receive(:get).with('my_key').and_return(nil)
      expect(AppSetting).to receive(:get).with('my_key')
      allow(AppSetting).to receive(:set).with('my_key', 'some_value')
      AppSetting.set_if_nil('my_key', 'some_value')
      expect(AppSetting).to have_received(:set).with('my_key', 'some_value')
    end
    it "for given key, for an existing record with non-nil value, it does nothing" do
      allow(AppSetting).to receive(:get).with('my_key').and_return('some_value')
      expect(AppSetting).to receive(:get).with('my_key')
      allow(AppSetting).to receive(:set).with('my_key', 'some_value')
      AppSetting.set_if_nil('my_key', 'some_another_value')
      expect(AppSetting).to_not have_received(:set)
    end
  end
  describe '.unset(k)' do
    it "for an existing record with non-nil value, sets its value to nil" do
      allow(AppSetting).to receive(:get).with('my_key').and_return('some_value')
      expect(AppSetting).to receive(:get).with('my_key')
      allow(AppSetting).to receive(:set).with('my_key', nil)
      AppSetting.unset('my_key')
      expect(AppSetting).to have_received(:set).with('my_key', nil)
    end
    it "for an non-existing record or an existing record with nil value, it does nothing" do
      allow(AppSetting).to receive(:get).with('my_key').and_return(nil)
      expect(AppSetting).to receive(:get).with('my_key')
      allow(AppSetting).to receive(:set).with('my_key', nil)
      AppSetting.unset('my_key')
      expect(AppSetting).to_not have_received(:set)
    end
  end
  describe '#to_s' do
    it "returns :my_key => 'some_value' for record with key 'my_key' and value 'some_value'" do
      app_setting = create(:app_setting, :key => 'my_key', :value => 'some_value')
      expect(app_setting.to_s).to eq(":my_key => 'some_value'")
    end
  end
  
  context "Tests relevant for only developer" do
    context 'Testing Associations' do
      # no associations
    end
    context 'Testing Callbacks' do 
      it "before_validation -> calls '#underscore_the_key'" do 
        app_setting = build(:app_setting)
        allow(app_setting).to receive(:underscore_the_key)
        expect(app_setting).to receive(:underscore_the_key)
        app_setting.save
      end
      it "#underscore_the_key" do 
        app_setting = build(:app_setting, :key => 'MyKey')
        app_setting.valid?
        expect(app_setting.key).to eq('my_key')
      end
    end
  end
end
