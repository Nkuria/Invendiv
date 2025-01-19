class UpdateLeaderboardJob < ApplicationJob
  queue_as :default

  def perform(page: 1, per_page: 10)
    LeaderboardService.update_leaderboard(page:, per_page:)
  rescue StandardError => e
    Rails.logger.error("Error in UpdateLeaderboardJob: #{e.message}")
  end
end
