require 'sinatra'
require_relative '../config/application'
require 'sequel/extensions/pagination'

post '/event' do
  EventWorker.perform_async(params)
end

get '/events' do
  per_page = 100
  @performed_actions = DB.from(:performed_actions).extension(:pagination).paginate(page.to_i, per_page)
  erb :events
end


def page
  params.fetch "page", 1
end