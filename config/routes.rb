Rails.application.routes.draw do
  get "/" => "home#index"
  resources :menu_items
  resources :users
  resources :orders
  resources :order_items
  resources :menus
  resources :offers

  get "/offers/new/:id" => "offers#new"
  post "/offers/:id" => "offers#create"
  get "/signin" => "sessions#new", as: :new_session
  post "/signin" => "sessions#create", as: :sessions
  delete "/signout" => "sessions#destroy", as: :destroy_session
end
