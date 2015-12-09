class Repo
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Conversion
  attr_accessor :id, :name, :description, :url

  # returns the "global" repo
  def self.global(config)
    new(
      id: config.github_repo,
      name: config.site_title,
      description: config.site_description,
      url: config.site_url
    )
  end

  def self.find(repo_full_name)
    result = Rails.cache.fetch(repo_full_name, expires_in: 10.minutes) do
      if Octokit.repository?(repo_full_name)
        Octokit.repository(repo_full_name).to_attrs
      end
    end
    return nil if result.nil?
    new(
      id: repo_full_name,
      name: result[:name],
      description: result[:description],
      url: result[:homepage]
    )
  end
end
