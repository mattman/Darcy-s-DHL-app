class Admin::BatchImportsController < AdminController 

  def packages
    attempt_import! :package, params[:packages_file], admin_packages_path
  end

  def carriers
    attempt_import! :carrier, params[:carriers_file], admin_carriers_path
  end

  def locations
    attempt_import! :package_location, params[:locations_file], admin_packages_path
  end

  def customers
    attempt_import! :customer, params[:customers_file], admin_customers_path
  end

  def batch_filter
    contents = params[:batch_filter_file].read rescue ""
    identifiers = contents.split(/[\s\,]+/).join(",")
    redirect_to admin_packages_path(:serial_number => identifiers)
  end

  protected

  def attempt_import!(name, file, url)
    if file.blank?
      flash[:alert] = "Unable to import data - No file was passed through."
      redirect_to url
      return
    end
    if BatchImporter.import!(name, file, options_for_import)
      flash[:notice] = "Successfully imported data into the system." 
    else
      flash[:alert] = "Error importing data - please check your file and try again."
    end
    redirect_to url
  end

  def options_for_import
    if admin?
      {}
    else
      {:carrier_id => current_user.id}
    end
  end

end
