require 'sinatra'
require 'kaminari'
require_relative '../config/application'
require_relative 'dto/performed_action'
require 'sequel/extensions/pagination'

post '/event' do
  EventWorker.perform_async(params)
end

get '/events' do
  @performed_actions = events
  erb :events
end

# return[Dto::PerformedAction]
def events
  collection = if params_page == 1 or nil
                 cached_events || events_from_db
               else
                 events_from_db
               end
  to_dto(collection)
end

def params_page
  (params.fetch "page", 1).to_i
end

def cached_events
  cache = Cache::PerformedAction.new
  cache.hashes
end

def events_from_db
  per_page = 100
  Kaminari.paginate_array(DB.from(:performed_actions).to_a).page(params_page).per(per_page)
end

def to_dto(collection)
  dto_events = []
  collection.each do |elem|
    dto_events << Dto::PerformedAction.new(elem)
  end
  dto_events
end


def puts_debug(elem)
  puts "DEBUG"
  puts "DEBUG"
  puts elem.class
  puts "DEBUG"
  puts "DEBUG"
  puts elem.size
  puts "DEBUG"
  puts "DEBUG"
  puts params.inspect
  puts "DEBUG"
  puts "DEBUG"
end

