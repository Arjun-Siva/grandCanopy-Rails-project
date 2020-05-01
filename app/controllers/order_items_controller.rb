class OrderItemsController < ApplicationController
  def index
    @current_cart = session[:cart].dup
    render "index"
  end

  def create
    @current_cart = session[:cart].dup
    new_order = Order.new(
      user_id: @current_user.id,
      address: (params[:address] == "" ? @current_use.address : params[:address]),
      date: Time.now,
      status: "Order placed",
    )
    new_order.save
    @current_cart.each do |order_item|
      item = MenuItem.find(order_item["id"].to_i)
      OrderItem.create!(
        order_id: new_order.id,
        menu_item_id: item.id,
        menu_item_name: item.name,
        menu_item_price: item.price,
        quantity: order_item["quantity"].to_i,
      )
    end
    flash[:error] = "Your order has been placed successfully!"
    session[:cart] = nil
    redirect_to orders_path
  end
end
