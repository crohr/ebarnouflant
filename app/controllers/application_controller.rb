class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :find_repo!

  protected
    def can_refresh?
      @can_refresh ||= begin
        return false unless (request.headers['Cache-Control'] || "").include?('no-cache')
        throttled = true
        Rails.cache.fetch([current_repo.id, :cache_reset].join, expires_in: 15.seconds, race_condition_ttl: 10) do
          throttled = false
        end
        !throttled
      end
    end

    def find_repo!
      if request.subdomain.blank?
        @current_repo = Repo.global(AppConfig)
      else
        repo = Repo.find(request.subdomain.split(".", 2).join("/"))
        if repo.nil?
          render plain: "No blog available at this address", status: 404
        else
          @current_repo = repo
        end
      end
    end

    def current_repo
      @current_repo
    end
    helper_method :current_repo
end
