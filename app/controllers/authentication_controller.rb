class AuthenticationController < ApplicationController

  def admin_login
    if request.post?
      @user = Administrator.authenticate!(params[:username], params[:password])
      if @user
        self.current_user = @user
        flash[:notice] = 'Welcome back to Where R U'
        redirect_to :root
      else
        flash.now[:error] = "I'm sorry - I couldn't log you in with the requested details."
        render :action => 'admin_login'
      end
    end
  end

  def carrier_login
    if request.post?
      @user = Carrier.authenticate!(params[:identifier], params[:password])
      if @user
        self.current_user = @user
        flash[:notice] = 'Welcome back to Where R U'
        redirect_to :root
      else
        flash.now[:error] = "I'm sorry - I couldn't log you in with the requested details."
        render :action => 'carrier_login'
      end
    end
  end

  def logout
    self.current_user = nil
    flash[:alert] = 'Successfully logged you out - thanks!'
    redirect_to :root
  end

end
