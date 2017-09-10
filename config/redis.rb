require 'redis'
require 'singleton'

# module HistoryRedis
#   @connect = Redis.new(host: ENV['DB_HOST'], port: ENV['DB_REDIS_PORT'], db: 1,timeout: 1)
#
#   def self.connection
#     @connect
#   end
# end

class HistoryRedis
  include Singleton

    @connect = Redis.new(host: ENV['DB_HOST'], port: ENV['DB_REDIS_PORT'], db: 1,timeout: 1)

  def connection
    @connect
  end
end
