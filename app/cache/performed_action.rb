require_relative 'base'
require 'sequel/extensions/pagination'

class Cache
  class PerformedAction < Cache::Base

    # create hash and add hashes id to events set
    def create_event(performed_action)
      create_events_hash(performed_action)
      add_hash_to_set(performed_action[:id])
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
