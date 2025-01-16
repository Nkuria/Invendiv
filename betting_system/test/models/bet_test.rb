require 'test_helper'

class BetTest < ActiveSupport::TestCase
  test 'should be valid with all attributes' do
    bet = Bet.new(user: users(:one), game: games(:one), odd: odds(:one), stake: 100)
    assert bet.valid?
  end

  # Test for invalid bet without user
  test 'should be invalid without user' do
    bet = Bet.new(game: games(:one), odd: odds(:one), stake: 100)
    assert_not bet.valid?
  end
end
