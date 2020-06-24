class RemoveCategoryFromOrderItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :order_items, :category, :string
  end
end
