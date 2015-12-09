class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
    def can_refresh?
      return false unless (request.headers['Cache-Control'] || "").include?('no-cache')
      throttled = true
      Rails.cache.fetch(:cache_reset, expires_in: 15.seconds, race_condition_ttl: 10) do
        throttled = false
      end
      !throttled
    end

    def current_repo
      AppConfig.github_repo
    end
end
