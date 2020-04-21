class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in

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
      )
      new_user.save
    end
    redirect_to "/menu_items"
  end
end
