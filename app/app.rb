require 'sinatra'
require_relative '../config/application'
require 'sequel/extensions/pagination'

post '/event' do
  EventWorker.perform_async(params)
  # set_cache
end

get '/events' do
  # unless cache_exists?
  #   set_cache
  # end
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
  # Sidekiq.redis { |con| con.set('events_cache', 'cache') }
  p_a = DB.from(:performed_actions).extension(:pagination).paginate(1, 100)
  Sidekiq.redis do |con|
    p_a.each do |row|
      con.hmset('events_cache',
                'actor_id', row[:actor_id],
                'actor_type', row[:actor_type],
                'action', row[:action],
                'subject_type', row[:subject_type],
                'created_at', row[:created_at]
      )
    end
  end
end

def events
  if page == 1
    events_from_cache
  else
    events_from_db
  end
end

def events_from_cache
   Sidekiq.redis do |con|
    con.hgetall('events_cache',
                @performed_actions[:actor_id],
                @performed_actions[:actor_type],
                @performed_actions[:action],
                @performed_actions[:subject_type],
                @performed_actions[:created_at],
    )
  end
end

def events_from_db
  per_page = 100
  @performed_actions = DB.from(:performed_actions).extension(:pagination).paginate(page, per_page)
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

def del_cache
  Sidekiq.redis { |con| con.del('events_cache') }
end
