class User < ApplicationRecord
  validates :first_name, :surname, :email, presence: true
  validates :email, uniqueness: true
  has_secure_password
end
