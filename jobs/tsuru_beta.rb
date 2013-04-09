# Copyright (c) 2013 tsuru authors
# Use of this source code is governed by a BSD-style license that can be found
# in the LICENSE file.

require "./jobs/conn.rb"

include Mongo

def fetch
  widget_name = "tsuru-beta"
  db = connect()
  send_event widget_name, { current: db["users"].count }
end

fetch
SCHEDULER.every '3m' do
  fetch
end
