require 'spec_helper'

describe FlagsWord do
  context 'Testing Validations' do
  end
  context "Tests relevant for only developer" do
    context 'Testing Associations' do
      it { should belong_to(:flag)}
      it { should belong_to(:word).touch(true)}
    end
    context 'Testing Callbacks' do
    end
  end
end
