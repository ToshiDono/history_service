require_relative '../../config/redis'

class Cache
  class Base
    def list_exists?(list)
      redis_connect { |con| con.llen(list) != 0 }
    end

    private

    def create_hash(hash, keys)
      arr = []
      keys.each do |key|
        arr << key
        arr << hash[key.to_sym]
      end
      redis_connect do |con|
        con.hmset("cache:events:#{hash[:id]}",
            arr
        )
      end
    end

    def add_hash_to_list(list, id)
      redis_connect { |con| con.rpush(list, id) }
    end

    # return Redis.connect
    def redis_connect(*args, &b)
      con = HistoryRedis.instance.connection
      # Sidekiq.redis { |con| yield(con, *args) }
      yield(con, *args)
    end

  end
end