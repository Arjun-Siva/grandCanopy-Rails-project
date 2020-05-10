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
        type_of_user: "customer",
      )
      new_user.save
      user = User.find_by(mobile: params[:mobile])
      if user != nil && user.authenticate(params[:password])
        session[:current_user_id] = user.id
        redirect_to menu_items_path
      else
        flash[:error] = "We are facing some difficulties in authorizing you. Please sign in"
        redirect_to new_users_path
      end
    end
  end
end
