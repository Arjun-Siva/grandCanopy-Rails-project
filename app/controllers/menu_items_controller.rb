class MenuItemsController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    @current_cart = session[:cart].dup
    default_menu = Menu.find_by(default: true)
    @currentMenu = MenuItem.where("menu_id = ?", default_menu.id)
    render "index"
  end

  def create
  end

  def update
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
    redirect_to menu_items_path
  end

  def destroy
    id = params[:id]
    session[:cart].delete_if { |hashItem| hashItem["id"] == id.to_s }
    redirect_to menu_items_path
  end
end
