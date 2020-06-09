class MenusController < ApplicationController
  def index
    ensure_owner_logged_in
    @menus = Menu.all
    render "index"
  end

  def create
    name = params[:name]
    Menu.create!(name: name, default: false)
    redirect_to menus_path
  end

  def update
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
    redirect_to menus_path
  end

  def destroy
    id = params[:menu]
    menu = Menu.find(id)
    menu.destroy
    redirect_to menus_path
  end
end
