require 'redis'
require 'singleton'

class HistoryRedis
  include Singleton

  def connection
    @connect ||= Redis.new(host: ENV['DB_HOST'], port: ENV['DB_REDIS_PORT'], db: 1,timeout: 1)
  end
end
