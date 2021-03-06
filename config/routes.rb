Whereru2::Application.routes.draw do |map|
  
  namespace :admin do
    resources :carriers
    resources :packages do
      member do
        post :update_status
        get  :update_status
      end
    end
    resources :customers

    post 'import/packages',  :to => 'batch_imports#packages',  :as => :import_packages
    post 'import/carriers',  :to => 'batch_imports#carriers',  :as => :import_carriers
    post 'import/locations', :to => 'batch_imports#locations', :as => :import_locations
    post 'import/customers', :to => 'batch_imports#customers', :as => :import_customers

    post 'packages/batch-filter', :to => 'batch_imports#batch_filter', :as => :import_batch_filter

  end

  match 'carriers/login'  => "authentication#carrier_login", :as => :carrier_login
  match 'carriers/logout' => "authentication#logout",         :as => :carrier_logout
  match 'admin/login'     => "authentication#admin_login",    :as => :admin_login
  match 'admin/logout'    => "authentication#logout",         :as => :carrier_logout
  match 'logout'          => "authentication#logout",         :as => :logout

  match 'packages/search', :to => 'packages#search', :as => :search_packages
  root :to => "packages#index"
end
