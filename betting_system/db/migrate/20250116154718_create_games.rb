class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.references :home_team, foreign_key: { to_table: :teams }, index: true
      t.references :away_team, foreign_key: { to_table: :teams }, index: true
      t.integer :status, index: true

      t.timestamps
    end
  end
end
