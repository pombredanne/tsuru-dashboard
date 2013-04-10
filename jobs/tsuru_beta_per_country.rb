# Copyright (c) 2013 tsuru authors
# Use of this source code is governed by a BSD-style license that can be found
# in the LICENSE file.

require "./jobs/conn.rb"

def get_users_per_country
  widget_name = "tsuru-beta-countries"
  db = connect()
  items = []
  countries = db["survey"].distinct("country")
  countries.each do |country|
    amount = db["survey"].find({country: country}).count()
    items.push({label: country, value: amount})
  end
  send_event widget_name, { items: items }
end

get_users_per_country
SCHEDULER.every '3m' do
  get_users_per_country
end
