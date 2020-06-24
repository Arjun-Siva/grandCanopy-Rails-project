class OrdersController < ApplicationController
  skip_before_action :ensure_cart_initialized
  skip_before_action :changePrices

  def index
    if check_owner
      ensure_owner_logged_in
      from = Date.parse session[:from_date].dup.to_s
      to = Date.parse session[:to_date].dup.to_s
      @orders = Order.where("created_at<=?", to).where("created_at>=?", from)
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
    orderId = params[:id].to_i
    @current_user = current_user
    if (Order.find(orderId)).user_id == (@current_user.id).to_i or check_owner
      @order_items = OrderItem.where("order_id = ?", orderId)
      if Comment.find_by(order_id: orderId) == nil
        if @current_user.type_of_user == "Customer"
          @show_comment = true
          render "show"
        else
          @show_comment = false
          render "show"
        end
      else
        @show_comment = false
        render "show"
      end
    else
      redirect_to orders_path
    end
  end
end
