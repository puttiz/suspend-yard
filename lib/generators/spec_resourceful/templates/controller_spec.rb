require File.dirname(__FILE__) + '<%= '/..' * controller_class_nesting_depth %>/../spec_helper'

describe <%= controller_class_name %>Controller do
  before(:each) do
    @params = {}
    controller.stubs(:params).returns(@params)
  end

  it "should ..."
end

describe <%= controller_class_name %>Controller, ":: index" do
  include SpecControllers
  include SpecHelpers
  before(:each) { stub_index }

  it "should ..."
end

describe <%= controller_class_name %>Controller, ":: new" do
  include SpecControllers
  include SpecHelpers
  before(:each) { stub_new }

  it "should ..."
end

describe <%= controller_class_name %>Controller, ":: create" do
  include SpecControllers
  include SpecHelpers
  before(:each) { stub_create }

  it "should ..."
end

describe <%= controller_class_name %>Controller, ":: show" do
  include SpecControllers
  include SpecHelpers
  before(:each) { stub_show }

  it "should ..."
end

describe <%= controller_class_name %>Controller, ":: edit" do
  include SpecControllers
  include SpecHelpers
  before(:each) { stub_edit }

  it "should ..."
end

describe <%= controller_class_name %>Controller, ":: update" do
  include SpecControllers
  include SpecHelpers
  before(:each) { stub_update }

  it "should ..."
end

describe <%= controller_class_name %>Controller, ":: destroy" do
  include SpecControllers
  include SpecHelpers
  before(:each) { stub_destroy }

  it "should ..."
end
