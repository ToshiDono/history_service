require 'sinatra'
require_relative '../config/application'
require 'sequel/extensions/pagination'

post '/event' do
  EventWorker.perform_async(params)
  set_cache
end

get '/events' do
  unless cache_exists?
    set_cache
  end
  per_page = 100
  # events
  @performed_actions = DB.from(:performed_actions).extension(:pagination).paginate(page, per_page)
  erb :events
end

def page
  (params.fetch "page", 1).to_i
end

def cache_exists?
  Sidekiq.redis { |con| con.get('events_cache') ? true : false }
end

def set_cache
  Sidekiq.redis { |con| con.set('events_cache', 'cache') }
end

def events
  if page == 1
    events_from_cache
  else
    events_from_db
  end
end

def events_from_cache

end

def events_from_db

end
