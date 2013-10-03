# Copyright (c) 2013 tsuru authors
# Use of this source code is governed by a BSD-style license that can be found
# in the LICENSE file.

require "json"
require "net/http"

milestones = [
  {number: 18, project: "tsuru", id: "public-cloud"},
  {number: 22, project: "tsuru", id: "private-docker"},
  {number: 15, project: "tsuru", id: "services2"},
  {number: 20, project: "tsuru", id: "ops"},
  {number: 21, project: "tsuru", id: "bugfix"},
]

def fetch(milestones)
  http = Net::HTTP.new "api.github.com", 443
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  milestones.each do |m|
    response = http.get "/repos/globocom/#{m[:project]}/milestones/#{m[:number]}"
    milestone = JSON.parse response.body
    closed = milestone["closed_issues"]
    if !closed || !milestone["open_issues"]
      return
    end
    total = closed + milestone["open_issues"]
    percent = 100.0 * closed / total
    send_event m[:id], { value: percent.ceil }
  end
end

fetch milestones
SCHEDULER.every "10m" do
  fetch milestones
end
