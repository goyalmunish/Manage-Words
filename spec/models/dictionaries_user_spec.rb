require 'spec_helper'

describe DictionariesUser do
  context 'Testing Validations' do
  end
  context "Tests relevant for only developer" do
    context 'Testing Associations' do
      it { should belong_to(:dictionary)}
      it { should belong_to(:user)}
    end
    context 'Testing Callbacks' do
    end
  end
end
