class MenuItemsController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    if check_customer or check_clerk
      @current_cart = session[:cart].dup
      default_menu = Menu.find_by(default: true)
      if default_menu == nil
        @current_menu = []
      else
        @currentMenu = MenuItem.where("menu_id = ?", default_menu.id)
      end
      render "index"
    elsif check_owner
      @menus = Menu.all
      @menu_items = MenuItem.all
      render "ownerIndex"
    end
  end

  def create
    if check_owner
      name = params[:name]
      category = params[:category]
      desc = params[:description]
      price = params[:price]
      menu_id = params[:menu_id]
      image = params[:image]
      new_item = MenuItem.new(name: name, category: category, description: desc, price: price, menu_id: menu_id, image: image)
      if new_item.save
        redirect_to menu_items_path
      else
        flash[:error] = new_item.errors.full_messages.join(", ")
        redirect_to menu_items_path
      end
    end
  end

  def edit
    if check_owner
      id = params[:id]
      @item = MenuItem.find(id.to_i)
      render "edit"
    else
      redirect_to menu_items_path
    end
  end

  def update
    if check_customer or check_clerk
      id = params[:id]
      quantity = params[:quantity]
      already_present = false
      session[:cart].each do |item|
        if item["id"].to_i == id.to_i
          already_present = true
          item["quantity"] = (item["quantity"].to_i) + (quantity.to_i)
        end
      end
      unless already_present
        (session[:cart]).push({ id: id, quantity: quantity })
      end
    elsif check_owner
      id = params[:id]
      item = MenuItem.find(id.to_i)
      item.name = params[:name]
      item.category = params[:category]
      item.description = params[:description]
      item.price = params[:price]
      item.menu_id = params[:menu]
      item.image = params[:image]
      item.save
    end
    redirect_to menu_items_path
  end

  def plusOne
    id = (params[:id]).to_i
    item = session[:cart].select { |i| i["id"].to_i == id }
    item[0]["quantity"] = item[0]["quantity"].to_i + 1
    redirect_to menu_items_path
  end

  def minusOne
    id = (params[:id]).to_i
    item = session[:cart].select { |i| i["id"].to_i == id }
    if item[0]["quantity"].to_i == 1
      redirect_to menu_items_path
    else
      item[0]["quantity"] = item[0]["quantity"].to_i - 1
      redirect_to menu_items_path
    end
  end

  def destroy
    if check_customer or check_clerk
      id = params[:id]
      session[:cart].delete_if { |hashItem| hashItem["id"] == id.to_s }
    else
      id = params[:id]
      MenuItem.find(id).destroy
    end
    redirect_to menu_items_path
  end
end
