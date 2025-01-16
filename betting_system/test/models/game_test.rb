require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'should be valid with teams' do
    game = Game.new(home_team: teams(:arsenal), away_team: teams(:chelsea))
    assert game.valid?
  end

  # Test the associations
  test 'should belong to home and away teams' do
    game = games(:one)
    assert_respond_to game, :home_team
    assert_respond_to game, :away_team
  end
end
