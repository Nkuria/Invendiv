class CreateBets < ActiveRecord::Migration[7.1]
  def change
    create_table :bets do |t|
      t.references :user, foreign_key: true, index: true
      t.references :game, foreign_key: true, index: true
      # t.references :team, foreign_key: true, index: true
      t.references :odd, foreign_key: true, index: true # The specific odds selected by the user
      t.decimal :stake, precision: 10, scale: 2, index: true
      # t.decimal :potential_payout, precision: 10, scale: 2
      t.integer :outcome

      t.timestamps
    end
  end
end
