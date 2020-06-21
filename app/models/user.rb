class User < ApplicationRecord
  validates :first_name, :email, :mobile, :password_confirmation, :address, presence: true
  validates :password, confirmation: true
  validates :password, length: { in: 6..20 }
  validates :mobile, length: { is: 10 }
  validates :email, :mobile, uniqueness: true
  has_secure_password
  has_many :orders
end
