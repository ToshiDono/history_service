require 'sinatra'
require_relative '../config/application'

post '/event' do
  EventWorker.perform_async(params[:event])
end

get '/events' do
end
