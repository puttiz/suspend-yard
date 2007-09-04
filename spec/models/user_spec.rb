require File.dirname(__FILE__) + '/../spec_helper'

module UserSpecHelper
  def create_user(options = {})
    User.create({ :username => 'mimosa',
                  :nickname => 'mimosa vivi',
                  :password => 'mimosapass',
                  :password_confirmation => 'mimosapass',
                  :email => 'mimosa@example.com',
                  :biography => 'A nurse with special habilities'
                }.merge(options))
  end
end

describe User, ":: First User" do

  include UserSpecHelper

  it "should become admin" do
    User.delete_all
    @user = create_user
    
    @user.should be_admin
    @user.should be_activated
  end

end

describe User, ":: A new user" do
  
  include UserSpecHelper
  
  it "should be created" do
    lambda{
      @user = create_user
      @user.should_not be_new_record
    }.should change(User, :count).by(1)
  end
  
  it "should require username" do
    lambda{
      @user = create_user(:username => nil)
      @user.should have_at_least(1).error_on(:username)
    }.should_not change(User, :count)
  end
  
  it "should require username between 3 and 20 characters in length" do

    lambda{
      @user = create_user(:username => 'no')
      @user.should have_at_least(1).error_on(:username)
    }.should_not change(User, :count)  

    lambda{
      @user = create_user(:username => 'looooooooooooooooooog')
      @user.should have_at_least(1).error_on(:username)
    }.should_not change(User, :count)

  end
  
  it "should require nickname as username when it's blank" do
    lambda{
      @user = create_user(:nickname => nil)
      @user.should_not be_new_record
      @user.nickname.should == @user.username
    }.should change(User, :count).by(1)
  end
  
  it "should require unique username & nickname (case insensitive)" do
    @user = create_user
    lambda{
      @u = create_user(:username => "MiMoSa")
      @u.should have_at_least(1).errors_on(:username)
    }.should_not change(User, :count)
  end
  
  it "should require password" do
    lambda{
      @user = create_user(:password => nil)
      @user.should have_at_least(1).error_on(:password)
    }.should_not change(User, :count)
  end
  
  it "should password confirmation" do
    lambda{
      @user = create_user(:password_confirmation => nil)
      @user.should have_at_least(1).error_on(:password_confirmation)
    }.should_not change(User, :count)
  end
  
  it "should password between 6 and 12 characters in length" do
    lambda{
      @user = create_user(:password => "short", :password_confirmation => "short")
      @user.should have_at_least(1).errors_on(:password)
    }.should_not change(User,:count)

    lambda{
      @user = create_user(:password => "looooooooooog", :password_confirmation => "looooooooooog")
      @user.should have_at_least(1).errors_on(:password)
    }.should_not change(User,:count)
  end
  
  it "should require email" do
    lambda{
      @user = create_user(:email => nil)
      @user.should have_at_least(1).errors_on(:email)
    }.should_not change(User, :count)
  end
  
  it "should require correct email" do
    lambda{
      @user = create_user(:email => 'mm')
      @user.should have_at_least(1).errors_on(:email)
    }.should_not change(User, :count)
  end
  
  it "should not be activated and be an admin" do
    @user = create_user
    
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
