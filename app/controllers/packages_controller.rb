class PackagesController < ApplicationController
  
  def index
    
  end
  
  def search
    @package = Package.find(:all, :conditions => ["serial_number = ?", params["package"]["serial_number"]], :include => [:intransit_notices, :delivered_notices])
  end
  
  def update
    
  end
  
  def new
    @package = Package.new
  end
  
  def create
    @package = Package.new(params[:package])
    customer = Customer.find_or_create_by_full_name(params[:customer])
    @package.customer = customer
    if @package.save
      flash[:notice] = "Created package successfully"
      redirect_to "/"
    else
      flash[:error] = "Sorry, there was an error in creating that package."
      render :action => "new"
    end
  end
  
end
