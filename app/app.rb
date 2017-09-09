require 'sinatra'
require_relative '../config/application'
require 'sequel/extensions/pagination'

post '/event' do
  EventWorker.perform_async(params)
end

get '/events' do
  page = params.fetch "page", 1
  per_page = 100
  @performed_actions = DB.from(:performed_actions).extension(:pagination).paginate(page.to_i, per_page.to_i)
  erb :events
end
