class CreateOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :offers do |t|
      t.integer :menu_item_id
      t.integer :original_price
      t.integer :offer_price
      t.datetime :from_date
      t.datetime :to_date

      t.timestamps
    end
  end
end
