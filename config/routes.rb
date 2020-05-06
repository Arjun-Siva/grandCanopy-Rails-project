Rails.application.routes.draw do
  get "/" => "home#index"
  resources :menu_items
  resources :users
  resources :orders
  resources :order_items
  get "/owner" => "owner#index", as: :owner
  post "/owner" => "owner#create"
  put "/owner/:id" => "owner#update"
  delete "/owner/:menu" => "owner#deleteMenu"
  delete "/owner/:menu/:item" => "owner#deleteItem"
  get "/signin" => "sessions#new", as: :new_session
  post "/signin" => "sessions#create", as: :sessions
  delete "/signout" => "sessions#destroy", as: :destroy_session
end
