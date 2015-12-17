class Video < ActiveRecord::Base

  belongs_to :user
  acts_as_votable
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true

  validates :vtitle, presence: true, length: { maximum: 100 }
  validates :vartist, presence: true, length: { maximum: 100 }
  validates :vrecord, presence: true, length: { maximum: 100 }
  validates :youtube_html, presence: true

  auto_html_for :youtube do
    html_escape
    image
    youtube(:width => 400, :height => 250)
    youtube
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

def self.search(search)
  where("vtitle LIKE ? OR vartist LIKE ? OR genre LIKE ? ", "%#{search}%", "%#{search}%", "%#{search}%")
end


end
