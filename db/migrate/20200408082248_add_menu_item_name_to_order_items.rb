class AddMenuItemNameToOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :menu_item_name, :string
  end
end
