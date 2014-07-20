require 'spec_helper'

describe User do
  context "without specific type" do
    it "is created as General by default" do
      user = build(:user)
      user.save!
      expect(user.type).to eq('General')
    end
  end
  context "with Admin as type" do
    subject { build(:admin_user) }
    it "is created as Admin" do
      subject.save!
      expect(subject.type).to eq('Admin')
    end
  end

  describe "#to_s" do
    it "returns email of the user " do
      user = create(:user, :email => 'user@user.com')
      expect(user.to_s).to eq('user@user.com')
    end
  end

  context 'Testing Validations' do
    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}
    it { should validate_presence_of(:email)}
    it { should validate_uniqueness_of(:email)}
    it { should ensure_length_of(:first_name).is_at_most(15) }
    it { should ensure_length_of(:last_name).is_at_most(15) }
    it { should ensure_length_of(:additional_info).is_at_most(100) }
  end

  context "Tests relevant for only developer" do
    context 'Testing Associations' do
      # Associations are structures, they shouldn't be tested
      it { should have_many(:words)}
      it { should have_many(:dictionaries_users)}
      it { should have_many(:dictionaries).through(:dictionaries_users)}
    end
  end

end
