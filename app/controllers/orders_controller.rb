class OrdersController < ApplicationController
  skip_before_action :ensure_cart_initialized
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
    elsif check_clerk
      ensure_clerk_logged_in
      @orders_info = Order.all.order(:created_at).reverse_order
      @order_items_info = OrderItem.all
      render "clerkIndex"
    else
      @myOrders = Order.where("user_id = ? ", @current_user.id).all.order(:created_at).reverse_order
      render "index"
    end
  end

  def create
    session[:from_date] = Date.parse params[:from_date]
    session[:to_date] = Date.parse params[:to_date]
    redirect_to orders_path
  end

  def update
    ensure_clerk_logged_in
    id = params[:id]
    order = Order.find((id.to_i))
    status = order.status
    if status == "Order placed"
      order.status = "Out for delivery"
    elsif status == "Out for delivery"
      order.status = "Delivered"
    end
    order.save
    redirect_to orders_path
  end

  def destroy
    ensure_clerk_logged_in
    id = params[:id]
    order = Order.find((id.to_i))
    order.status = "Order rejected"
    order.save
    redirect_to orders_path
  end

  def show
    orderId = params[:id]
    if (Order.find(orderId)).user_id == (@current_user.id).to_i or check_owner
      @order_items = OrderItem.where("order_id = ?", orderId)
      @show_comment = Comment.find_by(order_id: orderId) ? false : true
      render "show"
    else
      redirect_to orders_path
    end
  end
end
