class ApplicationController < ActionController::Base
  #protect_from_forgery
  layout 'application'
  
  def is_admin
    session["user"].class == "Administrator"
  end
  
  def is_carrier
    session["user"].class == "Carrier"
  end
  
end
