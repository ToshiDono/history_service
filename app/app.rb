require 'sinatra'
require 'sidekiq/web'
require_relative 'workers/event_worker'

post '/event' do
  EventWorker.perform_async(params[:event])
end

get '/sidekiq' do
  run Sidekiq::Web
end
