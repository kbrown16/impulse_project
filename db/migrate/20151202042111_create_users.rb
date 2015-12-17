class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.string :password
      t.string :username
      t.text :location
      t.text :bio
      t.text :interests

      t.timestamps null: false
    end
  end
end
