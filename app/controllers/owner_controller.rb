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
    Menu.create!(name: name)
    redirect_to owner_path
  end

  def deleteMenu
    id = params[:menu]
    menu = Menu.find(id)
    menu.destroy
    redirect_to owner_path
  end

  def update
    name = params[:name]
    category = params[:category]
    desc = params[:description]
    price = params[:price]
    menu_id = params[:id]
    MenuItem.create!(name: name, category: category, description: desc, price: price, menu_id: menu_id)
    redirect_to owner_path
  end

  def deleteItem
    menuItemId = params[:item]
    MenuItem.where("menu_id= ?", params[:menu]).find(menuItemId.to_i).destroy
    redirect_to owner_path
  end
end
