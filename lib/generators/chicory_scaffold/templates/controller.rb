class <%= controller_class_name %>Controller < ApplicationController
  make_resourceful do
    actions :all

    # Resourceful::Builder
    # actions   after   apply   before   belongs_to   build   new   publish   response_for
  end

  before_filter :cancel_to_index, :only => [:create, :update]

private

  def cancel_to_index
    redirect_to :action => :index if param[:cancel]
  end

end
