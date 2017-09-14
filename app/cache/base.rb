require_relative '../../config/redis'

class Cache
  class Base

    # checks the presence of a cache by the presence of a set with keys
    def set_exists?
      redis_connect { |con| !con.srandmember(set_name).nil? }
    end

    # return []
    def set
      redis_connect { |con| con.smembers(set_name) }
    end

    # return [{hash}]
    def hashes
      hashes = []
      redis_connect do |con|
        set.each do  |item|
          hashes << con.hgetall(hash_name(item))
        end
      end
      hashes
    end

    # removes hashes and set
    def destroy_cache
      set.each { |id| destroy_hash(id) }
      destroy_set
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

    def add_hash_to_set(id)
      redis_connect { |con| con.sadd(set_name, id)}
    end

    def destroy_set
      redis_connect { |con| con.del(set_name) }
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
