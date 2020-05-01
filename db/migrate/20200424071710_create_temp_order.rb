class CreateTempOrder < ActiveRecord::Migration[6.0]
  def change
    create_table :temp_orders do |t|
      t.string :status
    end
  end
end
