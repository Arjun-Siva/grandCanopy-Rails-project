class OwnerController < ApplicationController
  def index
    ensure_owner_logged_in
    @menus = Menu.all
    @menu_items = MenuItem.all
    render "index"
  end

  def create
    ensure_owner_logged_in
    name = params[:name]
    if Menu.where("name = ?", name)
      flash[:error] = "Menu name already exists"
      redirect_to owner_path
    else
      Menu.create!(name: name)
    end
    redirect_to owner_path
  end

  def show
    id = params[:id]
    Menu.find(id.to_i).destroy
    redirect_to owner_path
  end

  def update
    name = params[:name]
    category = params[:category]
    desc = params[:description]
    price = params[:price]
    menu_id = params[:id]
    MenuItem.create!(name: name, category: category, description: desc, price: price, menu_id: menu_id)
    redirect_tp owner_path
  end

  def destroy
    menuItemId = params[:id]
    MenuItem.find(menuItemId.to_i).destroy
    redirect_to owner_path
  end
end
