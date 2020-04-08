class AddCategoryToOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :category, :string
  end
end
