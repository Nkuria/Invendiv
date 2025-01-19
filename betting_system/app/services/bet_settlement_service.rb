class BetSettlementService
  def initialize(game, winner, draw: false)
    @game = game
    @winner = winner
    @draw = draw
  end

  def call
    ActiveRecord::Base.transaction do
      update_bets
      update_user_balances
    end
  end

  def update_bets
    if @draw
      Bet.for_game(game.id).update_all(outcome: 0)
      return
    end
    @winner.bets.update_all(outcome: 1)
    loser = @game.odds.where.not(id: @winner.id).first
    loser.bets.update(outcome: 0)
  end

  def update_user_balances
    return if @draw

    @winner.bets.each do |bet|
      user = bet.user
      user.update(balance: user.balance + bet.potential_payout)
    end
  end
end
