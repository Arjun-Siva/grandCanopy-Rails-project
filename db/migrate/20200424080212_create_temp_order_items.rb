class CreateTempOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :temp_order_items do |t|
      t.integer :menu_item_id
      t.integer :quantity
      t.integer :price
      t.string :name

      t.timestamps
    end
  end
end
