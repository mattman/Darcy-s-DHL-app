class CarriersController < ApplicationController
  
  before_filter :is_carrier
  
  def login
    if params[:login]
      @user = Carrier.find_by_identifier(params[:identifier])
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