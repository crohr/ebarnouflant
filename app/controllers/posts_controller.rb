class PostsController < ApplicationController
  def index
    page = (params[:p] || 1).to_i
    @posts = Rails.cache.fetch([:issues, page], cache_params) do
      Octokit.list_issues(AppConfig.github_repo, state: "closed", labels: "published", sort: "created", default: "desc", per_page: 10, page: page).map do |issue|
        # refresh the corresponding issue's cache while we're at it
        Rails.cache.write(issue[:number], issue.to_attrs, cache_params)
        issue.to_attrs
      end
    end.map{|issue| Post.load_from(issue)}
  end

  def show
    issue_number, slug = params[:id].split("-", 2)
    @post = Post.load_from(
      Rails.cache.fetch(issue_number, cache_params) do
        Octokit.issue(AppConfig.github_repo, issue_number).to_attrs
      end
    )
  end

  private
    def cache_params(opts = {})
      {expires_in: 15.minutes, race_condition_ttl: 10, force: params[:secret] == AppConfig.cache_reset_token}.merge(opts)
    end
end
