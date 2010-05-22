class ApplicationController < ActionController::Base
  layout 'application'

  include AuthenticationHelpers
  include AuthorizationHelpers

  protected

  def invalid_permissions
    flash[:error] = "I'm sorry, you don't have the correct permissions for that action"
    redirect_to :root
    return false
  end

end
