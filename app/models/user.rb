class User < ApplicationRecord
  validates :first_name, :email, :mobile, :password_confirmation, presence: true
  validates :password, confirmation: true
  has_secure_password
  has_many :orders
end
