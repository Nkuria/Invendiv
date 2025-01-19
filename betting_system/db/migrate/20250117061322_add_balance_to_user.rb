class AddBalanceToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :balance, :decimal, default: 0.0
    add_index :users, :balance
  end
end
