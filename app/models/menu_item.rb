class MenuItem < ApplicationRecord
  belongs_to :menu
  def self.addNewItem
    puts "Enter item name:"
    name = gets.chomp.to_s
    puts "Enter item description:"
    desc = gets.chomp.to_s
    puts "Enter price:"
    price = gets.chomp.to_i
    puts "Enter category"
    category = gets.chomp.to_s
    puts "Enter Menu id:"
    m_id = gets.chomp.to_i
    MenuItem.create!(name: name, description: desc, price: price, category: category, menu_id: m_id)
  end
end
