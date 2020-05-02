class ApplicationController < ActionController::Base
  before_action :ensure_user_logged_in
  before_action :ensure_cart_initialized

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

  def ensure_cart_initialized
    if session[:cart] == nil
      session[:cart] = Array.new
    end
  end

  def ensure_owner_logged_in
    unless @current_user.type_of_user = "Owner"
      redirect_to "/"
    end
  end
end
