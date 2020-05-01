class SessionsController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def new
  end

  def create
    user = User.find_by(mobile: params[:mobile])
    if user != nil && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to menu_items_path
    else
      flash[:error] = "Incorrect credentials! Please retry"
      redirect_to new_session_path
    end
  end

  def destroy
    session[:current_user_id] = nil
    @current_user = nil
    redirect_to "/"
  end
end
