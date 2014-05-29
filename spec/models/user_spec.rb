require 'spec_helper'

describe User do
  subject {build(:user)}
  context "without specific type" do
    it "is created as General by default" do
      subject.save!
      subject.type.should == 'General'
    end
  end
  context "with Admin as type" do
    subject {build(:admin_user)}
    it "is created as Admin" do
      subject.save!
      subject.type.should == 'Admin'
    end
  end
end
