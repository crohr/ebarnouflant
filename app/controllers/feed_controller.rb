require "rss"

class FeedController < ApplicationController
  def index
    @posts = Post.list(repo: current_repo.id, force: can_refresh?)
    respond_to do |format|
      format.xml
    end
  end
end
