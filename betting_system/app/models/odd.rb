class Odd < ApplicationRecord
  validates :value, :outcome, presence: true

  enum outcome: %i[pending win lose]

  belongs_to :game
  belongs_to :team
  has_many :bets
end
