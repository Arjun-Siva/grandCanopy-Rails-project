class OrdersController < ApplicationController
  def index
    @myOrders = Order.where("user_id = ? ", @current_user.id).all
    render "index"
  end

  def show
    orderId = params[:id]
    @order_items = OrderItem.where("order_id = ? ", orderId).all
    render "show"
  end
end
