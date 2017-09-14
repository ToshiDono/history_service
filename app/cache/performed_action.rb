# require_relative '../../config/application'
# require 'sequel/extensions/pagination'
require_relative 'base'

class Cache
  class PerformedAction < Cache::Base

    # checks the presence of a cache by the presence of a list with keys
    def list_exists?
      super('cache:events:list')
    end

    # create hash and add  add id hash to events list
    def create_event(performed_action)
      create_events_hash(performed_action)
      add_events_hash_to_list performed_action[:id]
    end

    # return [{event}]
    def events
      @performed_actions = []
      redis_connect do |con|
        events_ids.each do  |event|
          @performed_actions << con.hgetall("cache:events:#{event}")
        end
      end
      @performed_actions
    end

    # return [events list]
    def events_ids
      redis_connect do |con|
        events_size = con.llen('cache:events:list')
        events_list = con.lrange('cache:events:list', 0, events_size)
        events_list
      end
    end

    # removes hashes and event list
    def destroy_events_cache
      events_ids.each do |event_id|
        destroy_event(event_id)
      end
      destroy_events_list
    end

    private

    # create event hash
    def create_events_hash(performed_action)
      keys= ['actor_id', 'actor_type', 'action', 'subject_id', 'subject_type', 'created_at']
      create_hash(performed_action, keys)
    end

    # add id hash to events list
    def add_hash_to_list(id)
      super('cache:events:list', id)
    end

    # deletes the list of events
    def destroy_events_list
      redis_connect { |con| con.del('cache:events:list') }
    end

    # deletes the hash of events
    def destroy_event(id)
      redis_connect { |con| con.del("cache:events:#{id}") }
    end

    # # return Redis.connect
    # def redis_connect(*args, &b)
    #   con = HistoryRedis.instance.connection
    #   # Sidekiq.redis { |con| yield(con, *args) }
    #   yield(con, *args)
    # end
  end
end


