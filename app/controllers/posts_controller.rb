class PostsController < ApplicationController
  def index
    page = (params[:p] || 1).to_i
    @posts = Rails.cache.fetch([current_repo, :issues, page], cache_params) do
      Rails.logger.info "refreshing issues of #{current_repo} for page #{page}"
      Octokit.list_issues(current_repo, state: "closed", labels: "published", sort: "created", default: "desc", per_page: 10, page: page).map do |issue|
        # refresh the corresponding issue's cache while we're at it
        Rails.cache.write(issue[:number], issue.to_attrs, cache_params)
        issue.to_attrs
      end
    end.map{|issue| Post.load_from(issue)}
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

  private
    def cache_params(opts = {})
      throttled = true
      Rails.cache.fetch(:cache_reset, expires_in: 15.seconds, race_condition_ttl: 10) do
        throttled = false
      end
      force = [
        !throttled,
        (request.headers['Cache-Control'] || "").include?('no-cache')
      ]
      {expires_in: 15.minutes, race_condition_ttl: 10, force: force.all?}.merge(opts)
    end

    def current_repo
      AppConfig.github_repo
    end
end
