require 'redis'

REDIS = Redis.new(host: ENV['DB_HOST'], port: ENV['DB_REDIS_PORT'], db: 1,timeout: 1)
