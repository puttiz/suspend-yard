require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController, ":: Routes for REST UsersController should map" do

  it "{ :controller => 'users', :action => 'index' } to /users" do
    route_for(:controller => "users", :action => "index").should == "/users"
  end

  it "{ :controller => 'users', :action => 'show', :id => 1 } to /users/1" do
    route_for(:controller => "users", :action => "show", :id => 1).should == "/users/1"
  end

  it "{ :controller => 'users', :action => 'edit', :id => 1 } to /users/1/edit" do
    route_for(:controller => "users", :action => "edit", :id => 1).should == "/users/1/edit"
  end

  it "{ :controller => 'users', :action => 'update', :id => 1} to /users/1" do
    route_for(:controller => "users", :action => "update", :id => 1).should == "/users/1"
  end

  it "{ :controller => 'users', :action => 'destroy', :id => 1} to /users/1" do
    route_for(:controller => "users", :action => "destroy", :id => 1).should == "/users/1"
  end

end

describe UsersController, ":: Custom routes should map" do

  it "{ :controller => 'users', :action => 'new' } to /signup" #do
    #route_for(:controller => "users", :action => "new").should == "/signup"
  #end

  it "{ :controller => 'users', :action => 'activate', token => 'code' } to /activate/code" #do
    #route_for(:controller => "users", :action => "activate").should eql("/activate")
  #end

end

describe UsersController, ":: A new user" do

  include UserSpecHelper

  it "should allow signup"do
    @user = mock_model(User, :save => true)
    User.stub!(:new).and_return(@user)

    post :create, :user => valid_user_attributes
    response.should redirect_to(user_url(@user))
  end

  it "should fall back to new if save failed" do
    post :create, :user => valid_user_attributes.except(:username)
    assigns(:user).should have_at_least(1).errors_on(:username)
    response.should render_template('new')
  end

end

describe UsersController, ":: User with fixtures loaded" do

  it "should enable unactivated user with valid code"

  it "should not enable activated user with valid code"

  it "should not enable user with invalid code"

  it "should not access protected actions until user logined"

end

describe UsersController, ":: Only admin can" do

  it "edit all users"

  it "update all fields of user"

  it "destroy users"

  it "set admin properties"

end
