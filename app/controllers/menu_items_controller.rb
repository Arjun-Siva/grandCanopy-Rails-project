class MenuItemsController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    @current_cart = get_cart.dup
    render "index"
  end

  def create
  end

  def update
    id = params[:id]
    item = MenuItem.find(id)
    new_item = {
      id: item.id,
      name: item.name,
      price: item.price,
      quantity: params[:quantity],
    }
    put_cart(new_item)
    redirect_to menu_items_path
  end
end
