require 'sinatra'
require_relative '../config/application'

post '/event' do
  EventWorker.perform_async(params)
end

get '/events' do
  pa = DB.from(:performed_actions)
  "#{pa.all}"
end
