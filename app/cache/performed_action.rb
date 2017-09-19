require_relative 'base'
require 'sequel/extensions/pagination'

class Cache
  class PerformedAction < Cache::Base

    # create hash and add hashes id to events set
    def create_event(performed_action)
      create_events_hash(performed_action)
      add_hash_to_set(performed_action[:id])
    end

    # [events]
    def events_from_db
      DB.from(:performed_actions).extension(:pagination).paginate(1, 100)
    end

    def push_events_to_cache
      events_from_db.each { |event| create_event(event) }
    end

    private

    def hash_name(id)
      "cache:events:#{id}"
    end

    def set_name
      'cache:events:set'
    end

    # create event hash
    def create_events_hash(performed_action)
      keys= ['actor_id', 'actor_type', 'action', 'subject_id', 'subject_type', 'created_at']
      create_hash(performed_action, keys)
    end
  end
end
