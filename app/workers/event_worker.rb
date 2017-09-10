require_relative '../../config/redis'

class EventWorker
  include Sidekiq::Worker

  def perform(event)
    performed_actions = DB.from(:performed_actions)
    performed_actions.insert(event.merge(created_at: Time.now, updated_at: Time.now))
    increment_event
  end

  def increment_event
    HistoryRedis.instance.connection.incr('event')
  end
end
