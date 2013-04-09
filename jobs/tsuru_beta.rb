# Copyright (c) 2013 tsuru authors
# Use of this source code is governed by a BSD-style license that can be found
# in the LICENSE file.

require "json"
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
  db = MongoClient.new(host, port).db(database_name)
  # if user && password
  #   db.authenticate(user, password)
  # end
  db
end

def fetch
  widget_name = "tsuru-beta"
  db = connect()
  send_event widget_name, { current: db["users"].count }
end

fetch
SCHEDULER.every '3m' do
  fetch
end
