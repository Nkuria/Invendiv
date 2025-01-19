class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :surname
      t.string :email, index: { unique: true }
      t.boolean :verified, index: true
      t.string :password_digest

      t.timestamps
    end
    add_index :users, %i[first_name surname]
  end
end
