# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative 'db/tables/query'
require_relative 'db/sqlite3/postgres_credentials'
require_relative 'db/databases'
require_relative 'db/query'

set :port, ENV['PORT'] || '5000'
set :bind, '0.0.0.0'
set :public_folder, 'public'

get '/' do
  html('index')
end

get '/query' do
  html('query')
end

get '/execute/query' do
  uid = params['uid']
  query = params['query']
  database = params['database']

  status 200
  JSON.generate(Query.new(database_name: database, query: query, uid: uid).call)
rescue => e
  status 400

  JSON.generate({ message: e })
end

get '/list/databases' do
  uid = params['uid']
  values = Databases.new(uid).call
  view = 'database_card'
  key = 'datname'

  status 200

  partial_html(view, values, key)
rescue => e
  status 422

  JSON.generate({ message: e })
end

post '/connection' do
  @host = params['host']
  @username = params['username']
  @password = params['password']
  @port = params['port']

  status 200

  JSON.generate({ uid: uid })
rescue => e
  status 422

  JSON.generate({ message: e })
end

private

def uid
  PostgresCredentials.new.insert_credential(@host, @username, @password, @port)
end

def html(view)
  File.read("public/views/#{view}.html")
end

def partial_html(view, values, key)
  tag_str = File.read("public/views/partials/#{view}.html")

  values.map do |database_name|
    tag_str.gsub("$#{key}", database_name[key])
  end
end
