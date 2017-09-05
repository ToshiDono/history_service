require 'sinatra'

post '/event' do
  EventWorker.perform_async(params[:event])
end
