class Admin::PackagesController < Admin::BaseController

  ensure_user_type! :admin, :carrier, :only => [:index, :create, :new, :show]
  ensure_user_type! :admin, :only => [:edit, :destroy, :update]

  before_filter :check_read_permissions, :only => [:show]

  protected
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.all)
  end

  def end_of_association_chain
    scope = admin? ? Package : current_user.packages
    scope.filtered_scope(params)
  end

  def check_read_permissions
    if !resource.can_view?(current_user)
      flash[:alert] = "Can't view this package - sorry!"
      redirect_to :admin_packages
    end
  end

end
