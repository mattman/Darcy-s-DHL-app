class Admin::CarriersController < Admin::BaseController

  ensure_user_type! :admin, :except => :show
  ensure_user_type! :admin, :carrier, :only => :show

  protected
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.all)
  end

end
