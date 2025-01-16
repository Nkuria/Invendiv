class PublishOddUpdates
  include Sidekiq::Worker

  def perform(game_id)
    game = Game.find(game_id)

    home_odds = game.home_odds
    away_odds = game.away_odds

    publisher = WebSocketPublisher.new
    publisher.send_message({ event: 'requestOdds', game:, odds: { home: home_odds, away: away_odds } })
  end
end
