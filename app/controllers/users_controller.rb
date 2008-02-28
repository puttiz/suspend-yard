class UsersController < ApplicationController

  make_resourceful do
    actions :all

    #response_for :create do
      ##redirect_to user_path(@user)
      #redirect_to edit_user_path(@user)
    #end
  end

  def activate
    #respond_to do |format|
      #format.html do
        #self.current_user = User.find_by_token(params[:key])
        #if logged_in? && !current_user.activated?
          #current_user.toggle! :activated
          #flash[:notice] = "Signup complete!"[:signup_complete_message]
        #end
        #redirect_to CGI.unescape(params[:to] || home_path)
      #end
    #end
  end

end
