require 'test_helper'

class BetSettlementServiceTest < ActiveSupport::TestCase
  setup do
    @draw = false
    @game = games(:one)
    @winner = odds(:winning_odd)
    @loser = odds(:losing_odd)
  end

  test 'it updates bet outcomes when there is a winner' do
    service = BetSettlementService.new(@game, @winner, draw: false)

    service.call

    @winner.bets.each do |bet|
      assert_equal 'settled', bet.reload.outcome, 'Winning bets should have outcome set to 1'
    end

    @loser.bets.each do |bet|
      assert_equal 'lost', bet.reload.outcome, 'Losing bets should have outcome set to 0'
    end
  end

  test 'it updates user balances for winning bets' do
    service = BetSettlementService.new(@game, @winner, draw: false)

    bet = @winner.bets.last
    user = bet.user
    expected_balance = user.balance + bet.potential_payout
    service.call
    assert_equal expected_balance, user.reload.balance, 'User balance should be updated with potential payout'
  end

  test 'it sets all bets to outcome 0 in case of a draw' do
    service = BetSettlementService.new(@game, @winner, draw: true)

    service.call

    Bet.for_game(@game.id).each do |bet|
      assert_equal 'lost', bet.reload.outcome, 'All bets should have outcome set to 0 in case of a draw'
    end
  end

  test 'it does not update user balances in case of a draw' do
    service = BetSettlementService.new(@game, @winner, draw: true)

    service.call

    Bet.for_game(@game.id).each do |bet|
      user = bet.user
      assert_no_difference 'user.reload.balance', 'User balance should not change in case of a draw' do
        service.call
      end
    end
  end
end
