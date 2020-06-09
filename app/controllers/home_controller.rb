class HomeController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    OrderItem.group(:id).count
    render "index"
  end
end
