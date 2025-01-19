class LeaderboardService
  class << self
    def update_leaderboard(page: 1, per_page: 10)
      # Fetch the leaderboard data from cache or run the query
      leaderboard_data = Rails.cache.fetch("leaderboard_data_#{page}", expires_in: 1.hour) do
        # Handle the query with pagination, optimized for performance
        leaderboard = User.joins(:bets)
                          .where(bets: { outcome: 'settled' })
                          .group('users.id')
                          .select('users.id, users.first_name, users.surname, COUNT(bets.id) AS wins')
                          .order('wins DESC')
                          .limit(per_page)
                          .offset((page - 1) * per_page)

        # Optimize the query by reducing the number of fields loaded and filtering with 'settled' outcome
        leaderboard.map do |user|
          {
            user_id: user.id,
            first_name: user.first_name,
            surname: user.surname,
            wins: user.wins
          }
        end
      end

      # Publish the leaderboard data to WebSocket
      WebSocketPublisher.new.send_message({ event: 'requestLeaderboard', data: leaderboard_data })
    rescue StandardError => e
      Rails.logger.error("Error updating leaderboard: #{e.message}")
      # Log the exception
    end
  end
end
