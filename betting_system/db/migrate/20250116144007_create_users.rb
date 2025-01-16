class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :surname
      t.string :email
      t.boolean :verified
      t.string :password_digest

      t.timestamps
    end
  end
end
