class MenusController < ApplicationController
  skip_before_action :changePrices

  def index
    if check_owner
      @menus = Menu.all
      render "index"
    else
      redirect_to menu_items_path
    end
  end

  def create
    name = params[:name]
    Menu.create!(name: name, default: false)
    redirect_to menus_path
  end

  def update
    if check_owner
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
    end
    redirect_to menus_path
  end

  def destroy
    id = params[:menu]
    menu = Menu.find(id)
    menu.destroy
    redirect_to menus_path
  end
end
