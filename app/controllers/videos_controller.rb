class VideosController < ApplicationController

  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @video = current_user.videos.build(video_params)
    if @video.save
      flash[:success] = "Video Uploaded!"
      redirect_to current_user
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @video.destroy
    flash[:success] = "Video deleted"
    redirect_to request.referrer || user_path
  end

  def index

  end

def upvote
  @video = Video.find(params[:id])
  @video.upvote_by current_user
  redirect_to :back
end

def downvote
  @video = Video.find(params[:id])
  @video.downvote_by current_user
  redirect_to :back
end

  def index
    @videos = Video.all
  if params[:search]
    @videos = Video.search(params[:search]).order("created_at DESC")
  else
    @videos = Video.all.order('created_at DESC')
  end
end


  private

    def video_params
      params.require(:video).permit(:vtitle, :vartist, :vrecord, :youtube_html, :genre )
    end

    def correct_user
      @video = current_user.videos.find_by(id: params[:id])
      redirect_to user_path if @video.nil?
    end

end
