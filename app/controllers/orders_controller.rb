class OrdersController < ApplicationController
  skip_before_action :ensure_cart_initialized

  def index
    @myOrders = Order.where("user_id = ? ", @current_user.id).all.order(:created_at).reverse_order
    render "index"
  end

  def show_order
    orderId = params[:id]
    if (Order.find(orderId)).user_id == (@current_user.id).to_i
      @order_items = OrderItem.where("order_id = ?", orderId)
      render "show"
    else
      redirect_to orders_path
    end
  end
end
