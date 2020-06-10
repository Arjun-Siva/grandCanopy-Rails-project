Rails.application.routes.draw do
  get "/" => "home#index"
  resources :menu_items
  resources :users
  resources :orders
  resources :order_items
  resources :menus

  get "/signin" => "sessions#new", as: :new_session
  post "/signin" => "sessions#create", as: :sessions
  delete "/signout" => "sessions#destroy", as: :destroy_session
end
