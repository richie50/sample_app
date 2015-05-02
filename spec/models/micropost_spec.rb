require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }
 
  subject  { @micropost }
 
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  #test for valid micropost
  it { should be_valid }
  #post must have a user
  it { should respond_to(:user) }
  #primary table Foreign key should match child table foreign key
  its(:user) { should == user }
  
  describe "accessible attributes" do
    it " should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error) 
    end
  end
  
  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when user_id is present" do
    before { @micropost.user_id = user.id }
    it { should be_valid }
  end
  
  #Non empty content check
  describe "Content is empty " do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end
  
  #Non empty content check
  describe "Content is not empty " do
    before { @micropost.content = "a" * 139 }
    it { should be_valid }
  end
  
  #Non empty content check
  describe "Content is too long  " do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end

end
