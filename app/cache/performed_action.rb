# require_relative '../../config/application'
# require 'sequel/extensions/pagination'
require_relative '../../config/redis'

class Cache
  class PerformedAction

    # checks the presence of a cache by the presence of a list with keys
    def events_list_exists?# протестировано
      redis_connect { |con| con.llen('cache:events:list') != 0 }
    end

    # create hash and add  add id hash to events list
    def create_event(performed_action)
      create_events_hash(performed_action)
      add_events_hash_to_list performed_action[:id]
    end

    # create event hash
    def create_events_hash(performed_action)# протестировано
      redis_connect do |con|
        con.hmset("cache:events:#{performed_action[:id]}",
                  'actor_id', performed_action[:actor_id],
                  'actor_type', performed_action[:actor_type],
                  'action', performed_action[:action],
                  'subject_id', performed_action[:subject_id],
                  'subject_type', performed_action[:subject_type],
                  'created_at', performed_action[:created_at]
        )
      end
    end

    # add id hash to events list
    def add_events_hash_to_list(id)# протестировано
      redis_connect { |con| con.rpush('cache:events:list', id) }
    end

    # return [{event}]
    def events# протестировано
      @performed_actions = []
      redis_connect do |con|
        events_ids.each do  |event|
          @performed_actions << con.hgetall("cache:events:#{event}")
        end
      end
      @performed_actions
    end

    # return [events list]
    def events_ids # протестировано
      redis_connect do |con|
        events_size = con.llen('cache:events:list')
        events_list = con.lrange('cache:events:list', 0, events_size)
        events_list
      end
    end

    # removes hashes and event list
    def destroy_events_cache# протестировано
      events_ids.each do |event_id|
        destroy_event(event_id)
      end
      destroy_events_list
    end

    # deletes the list of events
    def destroy_events_list# протестировано
      redis_connect { |con| con.del('cache:events:list') }
    end

    # deletes the hash of events
    def destroy_event(id)# протестировано
      redis_connect { |con| con.del("cache:events:#{id}") }
    end

    private

    # return Redis.connect
    def redis_connect(*args, &b)# протестировано
      con = HistoryRedis.instance.connection
      # Sidekiq.redis { |con| yield(con, *args) }
      yield(con, *args)
    end
  end
end
