class OrderItemsController < ApplicationController
  skip_before_action :changePrices

  def index
    @current_cart = session[:cart].dup
    @offline_bill = @current_user.type_of_user == "Clerk"
    render "index"
  end

  def create
    @current_cart = session[:cart].dup
    offline_bill = @current_user.type_of_user == "Clerk"

    if offline_bill
      new_order = Order.new(
        user_id: @current_user.id,
        address: "In-hotel",
        date: Time.now,
        status: "Offline bill",
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
    else
      new_order = Order.new(
        user_id: @current_user.id,
        address: (params[:address] == "" ? @current_user.address : params[:address]),
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
    end

    flash[:error] = "Your order has been placed successfully!"
    session[:cart] = nil
    redirect_to orders_path
  end
end
