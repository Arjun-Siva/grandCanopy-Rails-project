class HomeController < ApplicationController
  skip_before_action :ensure_user_logged_in
  skip_before_action :changePrices

  def index
    current_user
    @offers = Offer.where("from_date <= ?", Date.today).where("to_date >= ?", Date.today)
    t = OrderItem.select(:menu_item_id).group(:menu_item_id).count()
    k = t.keys
    k = k.sort_by { |key| [t[key]] }
    @top5 = MenuItem.where(id: [k[-1], k[-2], k[-3], k[-4], k[-5]])
    render "index"
  end

  def else
    render "missing"
  end

  def about
    render "about"
  end
end
