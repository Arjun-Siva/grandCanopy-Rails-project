class AddTempOrderIdToTempOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :temp_order_items, :temp_order_id, :integer
  end
end
