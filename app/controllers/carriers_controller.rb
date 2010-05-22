class CarriersController < ApplicationController
  
  before_filter :is_carrier, :only => [:index]
  before_filter :is_admin, :only => [:new, :create]
  
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
  
  def new
    @carrier = Carrier.new
  end
  
  def create
    @carrier = Carrier.new(params[:carrier])
    if @carrier.save
      flash[:notice] = "Successfully created carrier"
      redirect_to("/admin")
    else
      flash[:error] = "Could not create new carrier"
      render :action => "new"
    end
  end
  
  def edit
    @carrier = Carrier.find(params[:id])
  end
  
  def method_name
    
  end
  

end