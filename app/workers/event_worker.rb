class EventWorker
  include Sidekiq::Worker

  def perform(event)
  end
end
