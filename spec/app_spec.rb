require_relative 'spec_helper'
require_relative '../app/app'

describe 'app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET#events' do
    it 'response to be ok' do
      get '/events'
      expect(last_response).to be_ok
    end
  end

  describe 'POST#event' do
    it 'response to be ok' do
      post '/event'
      expect(last_response).to be_ok
    end
  end
end
