# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
expiredOffers = Offer.where("to_date < ?", Date.today)
expiredOffers.each do |offer|
  item = MenuItem.find(offer.menu_item_id)
  item.price = offer.original_price
  item.save
  offer.destroy
end

currentOffers = Offer.where("from_date <= ?", Date.today).where("to_date >= ?", Date.today)
currentOffers.each do |offer|
  item = MenuItem.find(offer.menu_item_id)
  item.price = offer.offer_price
  item.save
end
