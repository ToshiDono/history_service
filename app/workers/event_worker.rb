require_relative '../config/sidekiq'

class EventWorker
  include Sidekiq::Worker

  def perform(event)
  end
end