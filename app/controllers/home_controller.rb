class HomeController < ApplicationController
  skip_before_action :ensure_user_logged_in
  skip_before_action :changePrices

  def index
    current_user
    @offers = Offer.where("from_date <= ?", Date.today).where("to_date >= ?", Date.today)
    OrderItem.group(:id).count
    render "index"
  end
end
