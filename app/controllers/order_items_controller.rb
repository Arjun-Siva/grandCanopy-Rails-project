class OrderItemsController < ApplicationController
  skip_before_action :changePrices

  def index
    if check_owner
      ensure_owner_logged_in
      from = Date.parse session[:from_date].dup.to_s
      to = Date.parse session[:to_date].dup.to_s
      @onlineData = {}
      @offlineData = {}
      onlineOrderIds = Order.where("date >= ? and date <= ?", from, to).where("status= ? ", "Delivered").select(:id)
      offlineOrderIds = Order.where("date >= ? and date <= ?", from, to).where("status= ? ", "Offline bill").select(:id)
      onlineOrderIds.each do |id|
        orderItems = OrderItem.where("order_id = ?", id.id)
        orderItems.each do |item|
          if @onlineData[item.menu_item_id] == nil
            @onlineData[item.menu_item_id] = { "name" => item.menu_item_name,
                                               "quantity" => item.quantity,
                                               "subtotal" => item.quantity * item.menu_item_price }
          else
            @onlineData[item.menu_item_id]["name"] = item.menu_item_name
            @onlineData[item.menu_item_id]["quantity"] += item.quantity
            @onlineData[item.menu_item_id]["subtotal"] += (item.quantity * item.menu_item_price)
          end
        end
      end
      offlineOrderIds.each do |id|
        orderItems = OrderItem.where("order_id = ?", id.id)
        orderItems.each do |item|
          if @offlineData[item.menu_item_id] == nil
            @offlineData[item.menu_item_id] = { "name" => item.menu_item_name,
                                                "quantity" => item.quantity,
                                                "subtotal" => item.quantity * item.menu_item_price }
          else
            @offlineData[item.menu_item_id]["name"] = item.menu_item_name
            @offlineData[item.menu_item_id]["quantity"] += item.quantity
            @offlineData[item.menu_item_id]["subtotal"] += (item.quantity * item.menu_item_price)
          end
        end
      end
      @onlineOrders = onlineOrderIds.length
      @offlineOrders = offlineOrderIds.length
      render "ownerIndex"
    else
      @current_cart = session[:cart].dup
      @offline_bill = @current_user.type_of_user == "Clerk"
      render "index"
    end
  end

  def create
    if check_owner
      session[:from_date] = Date.parse params[:from_date].to_s
      session[:to_date] = Date.parse params[:to_date].to_s
      redirect_to order_items_path
    else
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
end
