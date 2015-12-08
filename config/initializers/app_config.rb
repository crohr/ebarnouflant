AppConfig = OpenStruct.new
AppConfig.github_repo = ENV.fetch('GITHUB_REPO') { "crohr/ebarnouflant" }
AppConfig.cache_reset_token = ENV.fetch('CACHE_RESET_TOKEN') { "secret" }
