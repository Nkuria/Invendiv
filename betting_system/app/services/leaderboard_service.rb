class LeaderboardService
  class << self
    def update_leaderboard
      # Fetch users ordered by the number of wins in descending order
      leaderboard = User.joins(:bets)
                        .where(bets: { outcome: 'settled' })
                        .group('users.id')
                        .select('users.id, users.first_name, users.surname, COUNT(bets.id) AS wins')
                        .order('wins DESC')

      # Extract the leaderboard data
      leaderboard_data = leaderboard.map do |user|
        {
          user_id: user.id,
          first_name: user.first_name,
          surname: user.surname,
          wins: user.wins
        }
      end

      # Publish the leaderboard data
      WebSocketPublisher.new.send_message({ event: 'requestLeaderboard', data: leaderboard_data })
    end
  end
end
