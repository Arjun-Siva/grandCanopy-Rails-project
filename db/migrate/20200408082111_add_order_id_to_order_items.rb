class AddOrderIdToOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :order_id, :integer
  end
end
