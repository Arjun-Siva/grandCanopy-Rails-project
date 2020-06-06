class AddImageToMenuItems < ActiveRecord::Migration[6.0]
  def change
    add_column :menu_items, :image, :string
  end
end
