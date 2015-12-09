require "rss"

class FeedController < ApplicationController
  def index
    @posts = Post.list(repo: current_repo, force: can_refresh?)
    respond_to do |format|
      format.xml
    end
  end
end
