ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'rack/test'
require 'faker'
require 'factory_bot'
require_relative 'support/database_cleaner'
require_relative 'support/actions_helper'
require 'support/factory_girl'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.example_status_persistence_file_path = "spec/examples.txt"

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed

  config.include Rack::Test::Methods
end
