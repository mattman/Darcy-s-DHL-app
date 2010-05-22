class Admin::CustomersController < Admin::BaseController
  protected
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.all)
  end
end
