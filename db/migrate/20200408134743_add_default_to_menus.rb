class AddDefaultToMenus < ActiveRecord::Migration[6.0]
  def change
    add_column :menus, :default, :boolean
  end
end
