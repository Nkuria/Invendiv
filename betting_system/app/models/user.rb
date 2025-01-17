class User < ApplicationRecord
  validates :first_name, :surname, :email, :balance, presence: true
  validates :email, uniqueness: true
  has_secure_password

  before_validation :set_balance

  has_many :bets

  def set_balance
    self.balance ||= 10
  end
end
