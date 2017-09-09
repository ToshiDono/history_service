require_relative '../../config/redis'

class EventWorker
  include Sidekiq::Worker

  def perform(event)
    performed_actions = DB.from(:performed_actions)
    performed_actions.insert(event.merge(created_at: Time.now, updated_at: Time.now))
    incr_event
  end

  def incr_event
    REDIS.incr('event')
  end
end
