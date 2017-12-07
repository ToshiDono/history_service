require 'sinatra'
require 'kaminari'
require 'will_paginate'
require 'will_paginate/array'
require_relative '../config/application'
require_relative 'dto/performed_action'

register WillPaginate::Sinatra

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

def per_page
  100
end

def cached_events
  collection = Cache::PerformedAction.new
  collection.hashes.to_a.paginate(page: params_page, per_page: per_page)
  # Kaminari.paginate_array(collection.hashes).page(params_page).per(100)
end

def events_from_db
  # DB.from(:performed_actions).extension(:pagination).paginate(params_page, per_page)
  DB.from(:performed_actions).to_a.paginate(page: params_page, per_page: per_page)
end

def to_dto(collection)
  dto_events = []
  collection.each do |elem|
    dto_events << Dto::PerformedAction.new(elem)
  end
  dto_events
end
