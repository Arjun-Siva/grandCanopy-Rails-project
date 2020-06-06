class OwnerController < ApplicationController
  def index
    ensure_owner_logged_in
    @menus = Menu.all
    @menu_items = MenuItem.all
    render "index"
  end

  def create
    ensure_owner_logged_in
    name = params[:name]
    Menu.create!(name: name, default: false)
    redirect_to owner_path
  end

  def deleteMenu
    id = params[:menu]
    menu = Menu.find(id)
    menu.destroy
    redirect_to owner_path
  end

  def update
    name = params[:name]
    category = params[:category]
    desc = params[:description]
    price = params[:price]
    menu_id = params[:id]
    image = params[:image]
    new_item = MenuItem.new(name: name, category: category, description: desc, price: price, menu_id: menu_id, image: image)
    if new_item.save
      redirect_to owner_path
    else
      flash[:error] = new_item.errors.full_messages.join(", ")
      redirect_to owner_path
    end
  end

  def deleteItem
    menuItemId = params[:item]
    MenuItem.where("menu_id= ?", params[:menu]).find(menuItemId.to_i).destroy
    redirect_to owner_path
  end

  def defMenu
    ensure_owner_logged_in
    @menus = Menu.all
    render "defMenu"
  end

  def changeDefMenu
    menu_id = (params[:id]).to_i
    menus = Menu.all
    menus.each do |menu|
      if menu.id == menu_id
        menu.default = true
        menu.save!
      else
        menu.default = false
        menu.save!
      end
    end
    redirect_to defMenu_path
  end

  def salesReport
    ensure_owner_logged_in
    from = Date.parse session[:from_date].dup
    to = Date.parse session[:to_date].dup
    @onlineData = {}
    @offlineData = {}
    onlineOrderIds = Order.where("date >= ? and date <= ?", from, to).where("status= ? ", "Delivered").select(:id)
    offlineOrderIds = Order.where("date >= ? and date <= ?", from, to).where("status= ? ", "Offline bill").select(:id)
    onlineOrderIds.each do |id|
      orderItems = OrderItem.where("order_id = ?", id.id)
      orderItems.each do |item|
        if @onlineData[item.menu_item_id] == nil
          @onlineData[item.menu_item_id] = { "name" => item.menu_item_name,
                                             "quantity" => item.quantity,
                                             "subtotal" => item.quantity * item.menu_item_price }
        else
          @onlineData[item.menu_item_id]["name"] = item.menu_item_name
          @onlineData[item.menu_item_id]["quantity"] += item.quantity
          @onlineData[item.menu_item_id]["subtotal"] += (item.quantity * item.menu_item_price)
        end
      end
    end
    offlineOrderIds.each do |id|
      orderItems = OrderItem.where("order_id = ?", id.id)
      orderItems.each do |item|
        if @offlineData[item.menu_item_id] == nil
          @offlineData[item.menu_item_id] = { "name" => item.menu_item_name,
                                              "quantity" => item.quantity,
                                              "subtotal" => item.quantity * item.menu_item_price }
        else
          @offlineData[item.menu_item_id]["name"] = item.menu_item_name
          @offlineData[item.menu_item_id]["quantity"] += item.quantity
          @offlineData[item.menu_item_id]["subtotal"] += (item.quantity * item.menu_item_price)
        end
      end
    end
    @onlineOrders = onlineOrderIds.length
    @offlineOrders = offlineOrderIds.length
    render "sales"
  end

  def updateSalesReport
    session[:from_date] = Date.parse params[:from_date]
    session[:to_date] = Date.parse params[:to_date]
    redirect_to sales_path
  end
end
