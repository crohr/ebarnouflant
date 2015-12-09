AppConfig = OpenStruct.new
AppConfig.github_repo = ENV.fetch('GITHUB_REPO') { "crohr/ebarnouflant" }
AppConfig.cache_reset_token = ENV.fetch('CACHE_RESET_TOKEN') { "secret" }
AppConfig.google_analytics_id = ENV.fetch('GOOGLE_ANALYTICS_ID') { nil }
AppConfig.site_title = ENV.fetch('SITE_TITLE') { "My Blog" }
