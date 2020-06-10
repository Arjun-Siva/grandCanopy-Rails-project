class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in
  skip_before_action :ensure_cart_initialized

  def new
    render "users/new"
  end

  def create
    mobile_num = params[:mobile]
    new_user = User.find_by(mobile: mobile_num)
    if new_user != nil
      flash[:error] = "Mobile number already exists"
    else
      new_user = User.new(
        first_name: params[:first_name],
        last_name: params[:last_name],
        mobile: params[:mobile],
        email: params[:email],
        address: params[:address],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        type_of_user: "Customer",
      )
      new_user.save
      user = User.find_by(mobile: params[:mobile])
      if user != nil
        if user.authenticate(params[:password])
          session[:current_user_id] = user.id
          redirect_to menu_items_path
        else
          redirect_to new_sessions_path, alert: "User already exists! Please sign in"
        end
      else
        redirect_to new_user_path, alert: new_user.errors.full_messages.join(", ")
      end
    end
  end
end
