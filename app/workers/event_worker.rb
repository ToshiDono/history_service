require_relative '../../config/redis'
require_relative '../cache/performed_action'

class EventWorker
  include Sidekiq::Worker

  def perform(event)
    performed_actions = DB.from(:performed_actions)
    performed_actions.insert(event.merge(created_at: Time.now, updated_at: Time.now))
    update_events_cache
    increment_event
  end

  def increment_event
    HistoryRedis.instance.connection.incr('event')
  end

  def update_events_cache
    cache = Cache::PerformedAction.new
    cache.destroy_cache
    cache.push_events_to_cache
  end
end
