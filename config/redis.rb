require 'redis'

module HistoryRedis
  def self.connection
    Redis.new(host: ENV['DB_HOST'], port: ENV['DB_REDIS_PORT'], db: 1,timeout: 1)
  end
end

REDIS = HistoryRedis.connection