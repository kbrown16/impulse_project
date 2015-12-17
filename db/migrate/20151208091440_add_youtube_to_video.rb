class AddYoutubeToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :youtube, :text
  end
end
