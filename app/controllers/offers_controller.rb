class OffersController < ApplicationController
  def index
    ensure_owner_logged_in
    @offers = Offer.where("from_date <= ?", Date.today).where("to_date >= ?", Date.today)
    render "index"
  end

  def new
    ensure_owner_logged_in
    @menu_item = MenuItem.find(params[:id])
    render "new"
  end

  def create
    ensure_owner_logged_in
    item = MenuItem.find(params[:id])
    Offer.create!(menu_item_id: item.id, original_price: item.price, offer_price: params[:offer_price], from_date: params[:from_date], to_date: params[:to_date])
    redirect_to "/offers"
  end

  def edit
    ensure_owner_logged_in
    @offer = Offer.find(params[:id])
    render "edit"
  end

  def update
    ensure_owner_logged_in
    offer = Offer.find(params[:id])
    offer.offer_price = params[:offer_price]
    offer.from_date = params[:from_date]
    offer.to_date = params[:to_date]
    offer.save
    redirect_to "/offers"
  end

  def destroy
    ensure_owner_logged_in
    Offer.find(params[:id]).destroy
    redirect_to "/offers"
  end
end
