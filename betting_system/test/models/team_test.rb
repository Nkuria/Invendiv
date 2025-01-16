require 'test_helper'

class TeamTest < ActiveSupport::TestCase
    # Test if team name is unique
    test 'team name should be unique' do
      team = Team.new(name: 'Arsenal')
      assert_not team.valid?
    end

    # Test association with games
    test 'should have many games' do
      team = teams(:arsenal)
      assert_respond_to team, :home_games
      assert_respond_to team, :away_games
    end
end
