class PostsController < ApplicationController
  def index
    page = (params[:p] || 1).to_i
    @posts = Post.list(repo: current_repo, page: page, force: can_refresh?)
  end

  def show
    issue_number, slug = params[:id].split("-", 2)
    @post = Post.find(issue_number, repo: current_repo, force: can_refresh?)
  end
end
