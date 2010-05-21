class AdminController < ApplicationController
  
  before_filter :is_admin
  
  def login
    if params[:login]
      @user = Administrator.find_by_username(params[:username])
      if !@user.nil? && @user.password == params[:password]
        session[:user] = @user
        flash[:notice] = "Successfully logged in as administrator"
        redirect_to 'admin/index'
      else
        flash[:notice] = "Could not find a user with those details"
        render :action => "login"
      end
    end
  end
  
  def logout
    session[:user] = nil
  end  
  
end