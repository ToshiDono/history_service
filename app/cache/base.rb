require_relative '../../config/redis'

class Cache
  class Base

    # checks the presence of a cache by the presence of a list with keys
    def list_exists?
      redis_connect { |con| con.llen(list_name) != 0 }
    end

    # return []
    def list
      redis_connect do |con|
        list_size = con.llen(list_name)
        list = con.lrange(list_name, 0, list_size)
        list
      end
    end

    # return [{hash}]
    def hashes
      hashes = []
      redis_connect do |con|
        list.each do  |item|
          hashes << con.hgetall(hash_name(item))
        end
      end
      hashes
    end

    # removes hashes and list
    def destroy_cache
      list.each do |id|
        destroy_hash(id)
      end
      destroy_list
    end

    private

    def create_hash(hash, keys)
      arr = []
      keys.each do |key|
        arr << key
        arr << hash[key.to_sym]
      end
      redis_connect do |con|
        con.hmset("cache:events:#{hash[:id]}", arr)
      end
    end

    def add_hash_to_list(id)
      redis_connect { |con| con.rpush(list_name, id) }
    end

    def destroy_list
      redis_connect { |con| con.del(list_name) }
    end

    def destroy_hash(id)
      redis_connect { |con| con.del(hash_name(id)) }
    end

    # return Redis.connect
    def redis_connect(*args, &b)
      con = HistoryRedis.instance.connection
      # Sidekiq.redis { |con| yield(con, *args) }
      yield(con, *args)
    end

  end
end
