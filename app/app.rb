require 'sinatra'
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
  collection = if page == 1
                 cached_events || events_from_db
               else
                 events_from_db
               end
  puts_debug(collection)
  collection = to_dto(collection)
  puts_debug(collection)
  collection
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
  DB.from(:performed_actions).extension(:pagination).paginate(page, per_page).to_a
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
  puts elem.inspect
  puts elem[0] if elem.class == 'Array'
  puts "DEBUG"
  puts "DEBUG"
end

