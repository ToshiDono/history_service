web: ruby app/app.rb
monitoring: bundle exec rackup config.ru --host 0.0.0.0 -p 9292
sidekiq: bundle exec sidekiq -r ./config/application.rb
