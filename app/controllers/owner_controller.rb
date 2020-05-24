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
    Menu.create!(name: name, default: false)
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
    new_item = MenuItem.new(name: name, category: category, description: desc, price: price, menu_id: menu_id)
    if new_item.save
      redirect_to owner_path
    else
      flash[:error] = new_item.errors.full_messages.join(", ")
      redirect_to owner_path
    end
  end

  def deleteItem
    menuItemId = params[:item]
    MenuItem.where("menu_id= ?", params[:menu]).find(menuItemId.to_i).destroy
    redirect_to owner_path
  end

  def defMenu
    ensure_owner_logged_in
    @menus = Menu.all
    render "defMenu"
  end

  def changeDefMenu
    menu_id = (params[:id]).to_i
    menus = Menu.all
    menus.each do |menu|
      if menu.id == menu_id
        menu.default = true
        menu.save!
      else
        menu.default = false
        menu.save!
      end
    end
    redirect_to defMenu_path
  end

  def salesReport
    ensure_owner_logged_in
    @allOrders = Order.all
    @allItems = OrderItem.all
    render "sales"
  end
end
