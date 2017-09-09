class EventWorker
  include Sidekiq::Worker

  def perform(event)
    performed_actions = DB.from(:performed_actions)
    performed_actions.insert(
        actor_id: event['actor_id'],
        subject_id: event['subject_id'],
        actor_type: event['actor_type'],
        subject_type: event['subject_type'],
        action: event['action'],
        created_at: Time.now,
        updated_at: Time.now
    )
  end
end
