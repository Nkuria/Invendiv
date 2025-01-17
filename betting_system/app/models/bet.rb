class Bet < ApplicationRecord
  belongs_to :user
  belongs_to :game
  belongs_to :odd

  after_update :calculate_leaderboard, if: :settled_outcome?

  validates :stake, presence: true

  enum outcome: %i[lost settled pending_outcome]

  def potential_payout
    stake * odd.value
  end

  def team
    odd.team
  end

  def calculate_leaderboard
    invalidate_leaderboard_cache
    LeaderboardService.update_leaderboard
  end

  def settled_outcome?
    outcome == 'settled'
  end

  def invalidate_leaderboard_cache
    Rails.cache.delete('leaderboard_data')
  end
end
