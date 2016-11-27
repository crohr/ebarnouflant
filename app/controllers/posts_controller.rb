class PostsController < ApplicationController
  def index
    @posts = Post.list(repo: current_repo.id, page: page, per_page: per_page, force: can_refresh?)
  end

  def show
    issue_number, slug = params[:id].split("-", 2)
    @post = Post.find(issue_number, repo: current_repo.id, force: can_refresh?)
  end

  protected
    def page
      @page ||= (params[:p] || 1).to_i
    end
    helper_method :page

    def per_page
      AppConfig.posts_per_page
    end
    helper_method :per_page
end
