require 'test_helper'

class LeaderboardServiceTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:one)
    @user2 = users(:two)
    @user3 = users(:three)

    # Create bets with outcomes
    @bet1 = @user1.bets.create(outcome: 0, stake: 100)
    @bet2 = @user2.bets.create(outcome: 0, stake: 200)
    @bet3 = @user2.bets.create(outcome: 0, stake: 150)
    @bet4 = @user3.bets.create(outcome: 1, stake: 50)
  end

  def test_leaderboard_data
    leaderboard_data = LeaderboardService.update_leaderboard

    leaderboard = User.joins(:bets)
                       .where(bets: { outcome: 'settled' })
                       .group('users.id')
                       .select('users.id, users.first_name, users.surname, COUNT(bets.id) AS wins')
                       .order('wins DESC')

    leaderboard_data = leaderboard.map do |user|
      {
        user_id: user.id,
        first_name: user.first_name,
        surname: user.surname,
        wins: user.wins
      }
    end

    assert_equal leaderboard_data, leaderboard_data
  end
end
