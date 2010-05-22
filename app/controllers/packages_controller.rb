class PackagesController < ApplicationController

  before_filter :prepare_customer, :only => :create

  def index
    logger.debug session["user"].class
    if is_carrier
      @carrier = Carrier.find(session["user"])
      @packages = Package.by_carrier(@carrier).all
      render :action => "list"
    elsif is_admin
      @packages = Package.all
      render :action => "list"
    else
      # display the search form for an end user
    end
  end
  
  def search
    @packages = Package.from_serial_number(params[:serial_number]).with_notices.all
  end
  
  def update

  end
  
  def new
    @customer = Customer.new
    @package  = @customer.packages.build
  end
  
  def create
    @package = @customer.packages.new(params[:package])
    if @package.save
      flash[:notice] = "Created package successfully"
      redirect_to "/"
    else
      flash[:error] = "Sorry, there was an error in creating that package."
      render :action => "new"
    end
  end

  protected

  def prepare_customer
    @customer = Customer.from_name(params[:customer][:first_name], params[:customer][:last_name], params[:customer])
  end
  
end
