class Game < ApplicationRecord
    belongs_to :home_team, class_name: 'Team'
    belongs_to :away_team, class_name: 'Team'
    has_many :bets
    has_many :odds

    enum status: %i[upcoming ongoing completed]

    def home_odds
      odds.find_by(team: home_team)
    end

    def away_odds
      odds.find_by(team: away_team)
    end

    def update_game_odds(new_home_odds, new_away_odds, home_outcome: nil, away_outcome: nil)
      home_outcome ||= home_odds.outcome
      away_outcome ||= away_odds.outcome

      home_odds.update(value: new_home_odds, outcome: home_outcome)
      away_odds.update(value: new_away_odds, outcome: away_outcome)

      PublishOddUpdates.perform_async(id)
    end

    def end_game(winner, draw: false)
      winning_odds = nil
      if draw
        odds.update_all(outcome: 3)
      elsif winner == 'away'
        winning_odds = away_odds
        away_odds.update(outcome: 1)
        home_odds.update(outcome: 2)
      elsif winner == 'home'
        winning_odds = home_odds
        away_odds.update(outcome: 2)
        home_odds.update(outcome: 1)
      end
      BetSettlementService.new(self, winning_odds).call
      update(status: 2)
    end
end
