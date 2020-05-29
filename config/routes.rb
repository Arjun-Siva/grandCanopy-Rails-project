Rails.application.routes.draw do
  get "/" => "home#index"
  resources :menu_items
  resources :users
  get "/orders/:id" => "orders#show_order"
  resources :orders
  resources :order_items
  resources :clerks

  get "/owner" => "owner#index", as: :owner
  post "/owner" => "owner#create"
  get "/owner/defaultMenu" => "owner#defMenu", as: :defMenu
  put "/owner/defaultMenu/:id" => "owner#changeDefMenu"
  get "/owner/sales" => "owner#salesReport", as: :sales
  post "/owner/sales" => "owner#updateSalesReport"
  put "/owner/:id" => "owner#update"
  delete "/owner/:menu" => "owner#deleteMenu"
  delete "/owner/:menu/:item" => "owner#deleteItem"

  get "/signin" => "sessions#new", as: :new_session
  post "/signin" => "sessions#create", as: :sessions
  delete "/signout" => "sessions#destroy", as: :destroy_session
end
