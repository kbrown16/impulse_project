class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.references :user, index: true, foreign_key: true
      t.text :vtitle
      t.text :vartist
      t.text :vrecord

      t.timestamps null: false
    end
    add_index :videos, [:user_id, :created_at]
  end
end
