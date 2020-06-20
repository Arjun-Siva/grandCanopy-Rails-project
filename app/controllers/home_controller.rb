class HomeController < ApplicationController
  skip_before_action :ensure_user_logged_in
  skip_before_action :changePrices

  def index
    current_user
    @offers = Offer.where("from_date <= ?", Date.today).where("to_date >= ?", Date.today)
    t = OrderItem.select(:menu_item_id).group(:menu_item_id).count()
    k = t.keys
    k = k.sort_by { |key| [t[key]] }
    @top3 = MenuItem.find([k[-1], k[-2], k[-3]])
    render "index"
  end
end
