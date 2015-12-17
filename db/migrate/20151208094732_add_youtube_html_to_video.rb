class AddYoutubeHtmlToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :youtube_html, :text
  end
end
