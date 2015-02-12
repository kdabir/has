# encoding: UTF-8

require './build'
require 'mongo'
require 'guillotine'

HEADERS_FOR_SHELL = {'Content-Type' => 'text/plain'}

## accepts only one parameter `check` with path patterns accepted by build
map '/dq' do
  run Proc.new { |env|
        commands_to_check = Rack::Request.new(env).params[:check.to_s] || "core/*"
        [200, HEADERS_FOR_SHELL, [build(commands_to_check)]]
      }
end

class Shorty < Guillotine::App
  adapter = begin
    mongo_uri = ENV['MONGOLAB_URI'] || 'mongodb://localhost:27017/dq'
    db_name = mongo_uri[%r{/([^/\?]+)(\?|$)}, 1]
    collection = Mongo::MongoClient.from_uri(mongo_uri).db(db_name).collection("shorty")
    Guillotine::MongoAdapter.new(collection)
  rescue
    Guillotine::MemoryAdapter.new
  end

  set :service => Guillotine::Service.new(adapter, ENV['DOMAIN_RESTRICTION'])
end

map '/check' do
  run Shorty
end

