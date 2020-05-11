class ClerksController < ApplicationController
  def index
    ensure_clerk_logged_in
    @orders_info = Order.all.order(:created_at).reverse_order
    @order_items_info = OrderItem.all
    render "index"
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
    redirect_to clerks_path
  end

  def destroy
    ensure_clerk_logged_in
    id = params[:id]
    order = Order.find((id.to_i))
    order.status = "Order rejected"
    order.save
    redirect_to clerks_path
  end
end
