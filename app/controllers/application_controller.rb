class ApplicationController < ActionController::Base
  before_action :ensure_user_logged_in
  @@cart = []

  def get_cart
    return @@cart
  end

  def put_cart(new_item)
    @@cart.push(new_item)
  end

  def destroy_cart
    @@cart = Array.new
  end

  def ensure_user_logged_in
    unless current_user
      redirect_to new_session_path
    end
  end

  def current_user
    return @current_user if @current_user
    current_user_id = session[:current_user_id]
    if current_user_id
      @current_user = User.find(current_user_id)
    else
      nil
    end
  end
end
