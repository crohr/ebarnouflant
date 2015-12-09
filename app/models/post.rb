class Post
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Conversion
  attr_accessor :id, :title, :body, :published_at, :updated_at, :comments_count, :comments_url

  def self.cache_params(opts = {})
    {expires_in: 15.minutes, race_condition_ttl: 10}.merge(opts)
  end

  def self.list(opts = {})
    force = opts.delete(:force)
    repo = opts.delete(:repo)
    opts = {state: "closed", labels: "published", sort: "created", default: "desc", per_page: 10, page: 1}.merge(opts)

    Rails.cache.fetch([repo, :issues, opts], cache_params(force: !!force)) do
      Rails.logger.info "refreshing issues of #{repo} for page #{opts[:page]}"
      Octokit.list_issues(repo, opts).map do |issue|
        # refresh the corresponding issue's cache while we're at it
        Rails.cache.write(issue[:number], issue.to_attrs, cache_params)
        issue.to_attrs
      end
    end.map{|issue| Post.load_from(issue)}
  end

  def self.find(id, opts = {})
    repo = opts[:repo]
    load_from(
      Rails.cache.fetch([repo, id], cache_params(force: !!opts.delete(:force))) do
        Rails.logger.info "refreshing issue #{repo}##{id}..."
        Octokit.issue(repo, id).to_attrs
      end
    )
  end

  def self.load_from(issue)
    new(
      id: issue[:number],
      title: issue[:title],
      body: issue[:body],
      published_at: issue[:closed_at],
      updated_at: issue[:updated_at],
      comments_count: issue[:comments].to_i,
      comments_url: issue[:html_url]
    )
  end

  def persisted?
    true
  end

  def excerpt
    @excerpt ||= body.split("\n").first
  end

  def content
    @content ||= begin
      Rails.cache.fetch(Digest::SHA256.digest(body), race_condition_ttl: 10) do
        Octokit.markdown(body, gfm: true).force_encoding(Encoding::UTF_8)
      end
    end
  end

  def to_param
    permalink
  end

  def permalink
    [id, title.parameterize].join("-")
  end
end
