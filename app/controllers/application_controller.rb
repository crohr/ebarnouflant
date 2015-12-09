class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
    def can_refresh?
      @can_refresh ||= begin
        return false unless (request.headers['Cache-Control'] || "").include?('no-cache')
        throttled = true
        Rails.cache.fetch(:cache_reset, expires_in: 15.seconds, race_condition_ttl: 10) do
          throttled = false
        end
        !throttled
      end
    end

    def current_repo
      if request.subdomain.blank?
        AppConfig.github_repo
      else
        request.subdomain.split(".", 2).join("/")
      end
    end
end
