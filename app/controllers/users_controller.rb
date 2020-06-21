class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in
  skip_before_action :ensure_cart_initialized
  skip_before_action :changePrices

  def new
    render "users/new"
  end

  def create
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
    if new_user.save
      session[:current_user_id] = user.id
      redirect_to "/"
    else
      redirect_to new_user_path, alert: new_user.errors.full_messages.join(", ")
    end
  end

  def index
    @current_user = current_user
    if @current_user != nil and @current_user.type_of_user == "Customer"
      render "index"
    else
      redirect_to new_sessions_path
    end
  end
end
