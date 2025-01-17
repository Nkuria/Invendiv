require 'test_helper'
require 'mocha/minitest'

class BetTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @bet = bets(:one)

    @user.update(balance: 500)
  end

  test 'should be valid with all attributes' do
    bet = Bet.new(user: users(:one), game: games(:one), odd: odds(:one), stake: 100)
    assert bet.valid?
  end

  # Test for invalid bet without user
  test 'should be invalid without user' do
    bet = Bet.new(game: games(:one), odd: odds(:one), stake: 100)
    assert_not bet.valid?
  end

  test 'settle_bet updates bet outcome and user balance' do
    @bet.stubs(:potential_payout).returns(100)

    @bet.settle_bet

    assert_equal 'settled', @bet.outcome, 'Bet outcome should be updated to settled (1)'
    assert_equal 600, @user.reload.balance, 'User balance should be updated correctly'
  end

  test 'settle_bet rolls back if user update fails' do
    @bet.stubs(:potential_payout).returns(100)
    User.any_instance.stubs(:update).raises(ActiveRecord::RecordInvalid)

    assert_raises(ActiveRecord::RecordInvalid) { @bet.settle_bet }
    assert_not_equal 1, @bet.outcome, 'Bet outcome should not be updated if transaction fails'
    assert_equal 500, @user.reload.balance, 'User balance should remain unchanged if transaction fails'
  end
end
