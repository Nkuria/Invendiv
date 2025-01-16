class CreateOdds < ActiveRecord::Migration[7.1]
  def change
    create_table :odds do |t|
      t.references :game, foreign_key: true, index: true
      t.references :team, foreign_key: true, index: true
      t.decimal :value, precision: 5, scale: 2
      t.integer :outcome

      t.timestamps
    end
  end
end
