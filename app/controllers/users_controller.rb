class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in
  skip_before_action :ensure_cart_initialized
  skip_before_action :changePrices

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
          redirect_to new_session_path, alert: "User already exists! Please sign in"
        end
      else
        redirect_to new_user_path, alert: new_user.errors.full_messages.join(", ")
      end
    end
  end

  def index
    @current_user = current_user
    if @current_user != nil and @current_user.type_of_user == "Customer"
      render "index"
    else
      redirect_to new_session_path
    end
  end

  def edit
    if check_customer or check_owner
      @user = current_user
      if @user.id == params[:id]
        render "edit"
      end
    else
      redirect_to "/"
    end
  end

  def update
    if check_customer or check_owner
      user = current_user
      user.first_name = params[:first_name]
      user.last_name = params[:last_name]
      user.email = params[:email]
      user.address = params[:address]
      user.save
      redirect_to users_path
    else
      redirect_to "/"
    end
  end

  def destroy
    if check_customer or check_owner
      User.find(params[:id]).destroy
      session[:current_user_id] = nil
      redirect_to "/"
    end
  end
end
