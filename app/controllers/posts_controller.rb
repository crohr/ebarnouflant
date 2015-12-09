class PostsController < ApplicationController
  def index
    page = (params[:p] || 1).to_i
    @posts = Post.retrieve(repo: current_repo, page: page, force: can_refresh?)
  end

  def show
    issue_number, slug = params[:id].split("-", 2)
    @post = Post.load_from(
      Rails.cache.fetch([current_repo, issue_number], cache_params) do
        Rails.logger.info "refreshing issue #{current_repo}##{issue_number}..."
        Octokit.issue(current_repo, issue_number).to_attrs
      end
    )
  end

end
