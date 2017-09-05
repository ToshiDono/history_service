require 'sinatra'
require 'sidekiq/web'
require_relative 'workers/event_worker'

post '/event' do
  EventWorker.perform_async(params[:event])
end

get '/events' do
end
