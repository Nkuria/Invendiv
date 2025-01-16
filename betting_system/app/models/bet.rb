class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :game
  belongs_to :odd

  after_update :calculate_leaderboard

  validates :stake, presence: true

  enum outcome: %i[lost settled]

  def potential_payout
    stake * odd.value
  end

  def team
    odd.team
  end

  def calculate_leaderboard
    LeaderboardService.update_leaderboard
  end
end
