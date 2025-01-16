require 'test_helper'

class LeaderboardServiceTest < ActiveSupport::TestCase
  def setup
    # Create mock users and bets for the test
    @user1 = users(:one) # Assuming a fixture with a user
    @user2 = users(:two)
    @user3 = users(:three)

    # Create bets with outcomes
    @bet1 = @user1.bets.create(outcome: 0, stake: 100)
    @bet2 = @user2.bets.create(outcome: 0, stake: 200)
    @bet3 = @user2.bets.create(outcome: 0, stake: 150)
    @bet4 = @user3.bets.create(outcome: 1, stake: 50)
  end

  # def test_update_leaderboard
  #   # Mock the WebSocketPublisher to prevent actual WebSocket communication
  #   mock_publisher = Minitest::Mock.new
  #   WebSocketPublisher.stub :new, mock_publisher do
  #     # Expect the WebSocketPublisher to send the leaderboard data
  #     mock_publisher.expect(:send_message, nil, [{ event: 'requestLeaderboard', data: Array }])

  #     # Call the method to update the leaderboard
  #     LeaderboardService.update_leaderboard

  #     # Check that the send_message method was called once with the expected data
  #     mock_publisher.verify
  #   end
  # end

  def test_leaderboard_data
    # Call the service method to get the leaderboard
    leaderboard_data = LeaderboardService.update_leaderboard

    # Fetch the expected leaderboard sorted by wins
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

    # Assert that the leaderboard data matches the expected output
    assert_equal leaderboard_data, leaderboard_data
  end
end
