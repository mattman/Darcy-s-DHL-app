class PackagesController < ApplicationController
  
  def index
    
  end
  
  def search
    @package = Package.find(:all, :conditions => ["serial_number = ?", params["package"]["serial_number"]], :include => [:intransit_notices, :delivered_notices])
  end
  
end
