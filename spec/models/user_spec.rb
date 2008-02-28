require File.dirname(__FILE__) + '/../spec_helper'

describe User, ":: First User" do

  include UserSpecHelper

  it "should become admin" do
    User.delete_all
    @user = User.new
    @user.attributes = valid_user_attributes
    @user.save

    @user.should be_admin
    @user.should be_activated
  end

end

describe User, ":: A new user" do

  include UserSpecHelper

  before(:each) do
    @user = User.new
  end

  it "should be valid and created" do
    lambda{
      @user.attributes = valid_user_attributes
      @user.should be_valid

      @user.save
      @user.should_not be_new_record
    }.should change(User, :count).by(1)
  end

  it "should require username" do
    @user.attributes = valid_user_attributes.except(:username)
    @user.should have_at_least(1).error_on(:username)
  end

  it "should require username between 3 and 20 characters in length" do

    @user.attributes = valid_user_attributes.with(:username => 'no')
    @user.should have_at_least(1).error_on(:username)

    @user.attributes = valid_user_attributes.with(:username => 'looooooooooooooooooog')
    @user.should have_at_least(1).error_on(:username)

  end

  it "should require nickname as username when it's blank" do
    @user.attributes = valid_user_attributes.except(:nickname)
    @user.save
    @user.nickname.should == @user.username
  end

  it "should require unique username & nickname (case insensitive)" do
    @user.attributes = valid_user_attributes
    @user.save

    @u = User.new
    @u.attributes = valid_user_attributes.with(:username => "MiMoSa")
    @u.should have_at_least(1).errors_on(:username)
  end

  it "should require password" do
    @user.attributes = valid_user_attributes.except(:password)
    @user.should have_at_least(1).error_on(:password)
  end

  it "should password confirmation" do
    @user.attributes = valid_user_attributes.except(:password_confirmation)
    @user.should have_at_least(1).error_on(:password_confirmation)
  end

  it "should password between 6 and 12 characters in length" do
    @user.attributes = valid_user_attributes.with(:password => "short", :password_confirmation => "short")
    @user.should have_at_least(1).errors_on(:password)

    @user.attributes = valid_user_attributes.with(:password => "looooooooooog", :password_confirmation => "looooooooooog")
    @user.should have_at_least(1).errors_on(:password)
  end

  it "should require email" do
    @user.attributes = valid_user_attributes.except(:email)
    @user.should have_at_least(1).errors_on(:email)
  end

  it "should require correct email" do
    @user.attributes = valid_user_attributes.with(:email => 'mm')
    @user.should have_at_least(1).errors_on(:email)
  end

  it "should not be activated and be an admin" do
    lambda{
      @user.attributes = valid_user_attributes.with(:username => 'testman', :password => 'password', :password_confirmation => 'password', :email => 'need@need.com' )
      @user.should be_valid
      @user.save
    }.should change(User, :count).by(1)

    @user.should_not be_admin
    @user.should_not be_activated
  end

end

describe User, ":: User with fixtures loaded" do
  fixtures :users

  it "should authenticate user" do
    users(:lin).should == User.authenticate('lin','test')
  end

  it "should reset password" do
    users(:lin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    users(:lin).should == User.authenticate('lin','new password')
  end

  it "should not rehash password" do
    lambda{
      users(:lin).update_attributes(:username => 'lin2')
    }.should change(users(:lin), :username)
    users(:lin).should == User.authenticate('lin2','test')
  end

  it "should protect against updates to secure attributes" do
    lambda{
      users(:joe).update_attributes(:admin => true)
    }.should_not change(users(:joe), :admin)
  end

  it "should set remember token" do
    users(:joe).should_not be_token
    lambda{
      users(:joe).remember_me
    }.should change(users(:joe), :token).from(nil)
    users(:joe).token_expires_at.should_not be_nil
    users(:joe).should be_token
  end

  it "should unset remember token" do
    lambda{
      users(:joe).remember_me
    }.should change(users(:joe), :token).from(nil)
    users(:joe).should be_token

    lambda{
      users(:joe).forget_me
    }.should change(users(:joe), :token).to(nil)
    users(:joe).should_not be_token
  end

  it "should be remembed for a period (2 weeks)" do
    before = 2.week.from_now.utc
    lambda{
      users(:joe).remember_me
    }.should change(users(:joe), :token).from(nil)
    after = 2.week.from_now.utc
    users(:joe).should be_token
    users(:joe).token_expires_at.should_not be_nil
    users(:joe).token_expires_at.should be_between(before, after)
  end
end
