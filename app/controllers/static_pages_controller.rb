class StaticPagesController < ApplicationController
  def help
  end

  def support
  end

  def about
  end

  def userfeed
    if logged_in?
      
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def home
    if logged_in?
      @video  = current_user.videos.build
      @feed_items = current_user.feed.paginate(page: params[:page], :per_page => 15)
    end
  end

  def surgefeed
    @videos = Video.paginate(page: params[:page], :per_page => 5)
  end

  def contact
  end
end

