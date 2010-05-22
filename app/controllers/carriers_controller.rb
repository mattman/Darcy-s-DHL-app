class CarriersController < ApplicationController
  
  ensure_user_type! :admin, :only => [:new, :create, :index]
  
  def login
    if request.post?
      @user = Carrier.authenticate!(params[:identifier], params[:password])
      if @user 
        self.current_user = @user
        flash[:notice] = "Successfully logged in"
        redirect_to '/'
      else
        flash.now[:notice] = "Could not find a user with those details"
        render :action => "login"
      end
    end
  end

  def logout
    self.current_user = nil
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
      flash.now[:error] = "Could not create new carrier"
      render :action => "new"
    end
  end

  def edit
    @carrier = Carrier.find(params[:id])
  end

end
