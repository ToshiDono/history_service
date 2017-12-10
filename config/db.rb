require 'sequel'

DB = Sequel.connect(
               adapter: :postgres,
               user: ENV['PGUSER'],
               password: ENV['PGPASSWORD'],
               host: ENV['DB_HOST'],
               port: ENV['DB_PG_PORT'],
               database: ENV['ENVPOSTGRES_DB']
)
