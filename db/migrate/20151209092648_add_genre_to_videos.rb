class AddGenreToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :genre, :text
  end
end
