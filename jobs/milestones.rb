# Copyright (c) 2013 tsuru authors
# Use of this source code is governed by a BSD-style license that can be found
# in the LICENSE file.

require "json"
require "net/http"

milestones = [
  {number: 17, id: "public-cloud"},
]

def fetch(milestones)
  http = Net::HTTP.new "api.github.com", 443
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  milestones.each do |m|
    response = http.get "/repos/globocom/tsuru/milestones/#{m[:number]}"
    milestone = JSON.parse response.body
    closed = milestone["closed_issues"]
    total = closed + milestone["open_issues"]
    percent = 100.0 * closed / total
    send_event m[:id], { value: percent.ceil }
  end
end

fetch milestones
SCHEDULER.every "10m" do
  fetch milestones
end
