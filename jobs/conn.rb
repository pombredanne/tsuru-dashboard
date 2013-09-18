require "mongo"

include Mongo

def connect
  if !ENV["MONGO_URI"] || !ENV["MONGO_DATABASE_NAME"]
   throw "You must configure the mongodb variables in order to start the dashboard."
  end
  uri = ENV["MONGO_URI"].split(":")
  user = ENV["MONGO_USER"]
  password = ENV["MONGO_PASSWORD"]
  database_name = ENV["MONGO_DATABASE_NAME"]
  host, port = uri[0], uri[1].to_i
  MongoClient.new(host, port).db(database_name)
end
