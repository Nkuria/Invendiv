# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create(first_name: 'user1', surname: 'user1 surname', email: 'user1mail@mail.com', password: '123456',
            verified: true)

teams = [
  'Arsenal', 'West Ham', 'Chelsea', 'Manchester City', 'Manchester United',
  'Liverpool', 'Wolves', 'Brentford', 'Ipswich', 'Nottingham', 'Tottenham',
  'Brighton', 'Southampton'
]

teams.each do |team_name|
  Team.create(name: team_name)
end

all_teams = Team.all

games = []
10.times do
  home_team = all_teams.sample
  away_team = all_teams.sample

  # Ensure home and away teams are not the same
  away_team = all_teams.sample while home_team == away_team

  # Create the game
  game = Game.create(
    home_team:,
    away_team:,
    status: 0
  )

  # Create odds for the game: Home Win and Away Win
  home_odds = Faker::Number.decimal(l_digits: 1, r_digits: 2)
  away_odds = Faker::Number.decimal(l_digits: 1, r_digits: 2)

  # Create the odds for both home and away teams
  Odd.create(game:, team: home_team, value: home_odds, outcome: 2)
  Odd.create(game:, team: away_team, value: away_odds, outcome: 1)

  games << game
end

puts "Created #{games.count} games with odds."

users = []
10.times do
  user = User.create(
    first_name: Faker::Name.first_name,
    surname: Faker::Name.last_name,
    password: Faker::Internet.password(min_length: 8),
    email: Faker::Internet.email,
    verified: Faker::Boolean.boolean
  )
  users << user
end

puts "Created #{users.count} users."

# Place random bets for each user
bets = []
users.each do |user|
  # Randomly select a game and odds
  game = games.sample
  odds = game.odds.sample # Home or Away odds

  stake = Faker::Number.decimal(l_digits: 2, r_digits: 2)

  bet = Bet.create(
    user:,
    game:,
    odd: odds, # The specific odd (team + outcome)
    stake:
  )

  bets << bet
end

puts "Created #{bets.count} bets for users."
