require 'sinatra'

post '/event' do
  @event = params[:event]
end
