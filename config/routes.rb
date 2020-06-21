Rails.application.routes.draw do
  get "/" => "home#index"
  put "/menu_items/:id/plusOne" => "menu_items#plusOne", as: :update_plusOne
  put "/menu_items/:id/minusOne" => "menu_items#minusOne", as: :update_minusOne
  resources :menu_items
  resources :users
  resources :orders
  resources :order_items
  resources :menus
  get "/offers/new/:id" => "offers#new"
  post "/offers/:id" => "offers#create"
  resources :offers
  get "/signin" => "sessions#new", as: :new_session
  post "/signin" => "sessions#create", as: :session
  delete "/signout" => "sessions#destroy", as: :destroy_session
end
