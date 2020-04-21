class OrderItemsController < ApplicationController
  def index
    @current_cart = get_cart.dup
    render "index"
  end

  def create
    @current_cart = get_cart.dup
    new_order = Order.new(
      user_id: @current_user.id,
      address: @current_user.address,
      date: Time.now,
      status: "Order placed",
    )
    new_order.save
    @current_cart.each do |order_item|
      OrderItem.create!(
        order_id: new_order.id,
        menu_item_id: order_item[:id],
        menu_item_name: order_item[:name],
        menu_item_price: order_item[:price],
        quantity: order_item[:quantity],
      )
    end
    flash[:error] = "Your order has been placed successfully!"
    destroy_cart
    redirect_to orders_path
  end
end
