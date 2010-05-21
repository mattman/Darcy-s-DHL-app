class ApplicationController < ActionController::Base
  #protect_from_forgery
  layout 'application'
  
  def is_admin
    session[:usertype] == "administrator"
  end
  
  def is_carrier
    session[:usertype] == "carrier"
  end
  
end
