class Order < ApplicationRecord
  has_many :order_items
  has_many :comment
  belongs_to :user
end
