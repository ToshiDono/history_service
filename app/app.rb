require 'sinatra'
require 'kaminari'
require 'kaminari/sinatra'
require_relative '../config/application'
require_relative 'dto/performed_action'

register Kaminari::Helpers::SinatraHelpers

post '/event' do
  EventWorker.perform_async(params)
end

get '/events' do
  @collection = events
  @performed_actions = to_dto(@collection)
  erb :events
end

# return[Dto::PerformedAction]
def events
  if params_page == 1 or nil
    cached_events || events_from_db
  else
    events_from_db
  end
end

def params_page
  (params.fetch "page", 1).to_i
end

def cached_events
  collection = Cache::PerformedAction.new
  Kaminari.paginate_array(collection.hashes).page(params_page).per(100)
end

def events_from_db
  per_page = 100
  DB.from(:performed_actions).extension(:pagination).paginate(page, per_page)
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

