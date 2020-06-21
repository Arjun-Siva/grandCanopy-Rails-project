class SessionsController < ApplicationController
  skip_before_action :ensure_user_logged_in
  skip_before_action :ensure_cart_initialized
  skip_before_action :changePrices

  def new
    if current_user == nil
      render "new"
    else
      redirect_to menu_items_path, alert: "You are already logged in"
    end
  end

  def create
    user = User.find_by(mobile: params[:mobile])
    if user != nil && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      if (user.type_of_user == "Customer")
        redirect_to menu_items_path
      elsif (user.type_of_user == "Clerk")
        redirect_to orders_path
      else
        redirect_to menu_items_path
      end
    else
      redirect_to new_session_path, alert: "Invalid credentials. Please try again!"
    end
  end

  def destroy
    session[:current_user_id] = nil
    @current_user = nil
    redirect_to "/"
  end
end
