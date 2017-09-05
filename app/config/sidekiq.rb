require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { db: 1, url: ENV['DB_HOST'], network_timeout: 5 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1, url: ENV['DB_HOST'], network_timeout: 5 }
end