# require_relative '../../config/application'
# require 'sequel/extensions/pagination'
require_relative 'base'

class Cache
  class PerformedAction < Cache::Base

    # create hash and add  add id hash to events list
    def create_event(performed_action)
      create_events_hash(performed_action)
      add_hash_to_list(performed_action[:id])
    end

    def list_name
      'cache:events:list'
    end

    def hash_name(id)
      "cache:events:#{id}"
    end

    private

    # create event hash
    def create_events_hash(performed_action)
      keys= ['actor_id', 'actor_type', 'action', 'subject_id', 'subject_type', 'created_at']
      create_hash(performed_action, keys)
    end
  end
end
