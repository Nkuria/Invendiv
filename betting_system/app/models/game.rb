class Game < ApplicationRecord
    belongs_to :home_team, class_name: 'Team'
    belongs_to :away_team, class_name: 'Team'
    enum status: %i[upcoming ongoing completed]
end
