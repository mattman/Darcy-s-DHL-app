class PackagesController < ApplicationController

  def index
    redirect_to :admin_packages if carrier? || admin?
  end

  def search
    @packages = Package.from_serial_number(params[:serial_number]).with_notices.all
  end

end
