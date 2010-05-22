Whereru2::Application.routes.draw do |map|
  match 'carriers/login' => "carriers#login"
  match 'carriers/logout' => "carriers#logout"
  match 'admin/login' => "admin#login"
  match 'admin/logout' => "admin#logout"
  resources :carriers
  resources :packages do
    collection do
      post :search
    end
  end
  root :to => "packages#index"
end
