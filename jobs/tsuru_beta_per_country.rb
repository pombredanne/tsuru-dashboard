# Copyright (c) 2013 tsuru authors
# Use of this source code is governed by a BSD-style license that can be found
# in the LICENSE file.

require "./jobs/conn.rb"

def fetch
  widget_name = "tsuru-beta-countries"
  db = connect()
  items = []
  countries = db["survey"].distinct("country")
  countries.each do |country|
    amount = db["survey"].count({country: country})
    items.push({label: country, value: amount})
  end
  send_event widget_name, { items: items }
end

fetch
SCHEDULER.every '3m' do
  fetch
end
