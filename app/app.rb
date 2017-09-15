require 'sinatra'
require_relative '../config/application'
require 'sequel/extensions/pagination'

post '/event' do
  EventWorker.perform_async(params)
end

get '/events' do
  @performed_actions = events
  erb :events
end

def events
  if page == 1
    cached_events || events_from_db
  else
    events_from_db
  end
end

def page
  (params.fetch "page", 1).to_i
end

def cached_events
  cache = Cache::PerformedAction.new
  cache.hashes
end

def events_from_db
  per_page = 100
  DB.from(:performed_actions).extension(:pagination).paginate(page, per_page)
end



def puts_events_cache
  puts "DEBUG"
  puts "DEBUG"
  puts "DEBUG"
  Sidekiq.redis { |con| puts con.get('events_cache').inspect }
  puts "DEBUG"
  puts "DEBUG"
  puts "DEBUG"
end

