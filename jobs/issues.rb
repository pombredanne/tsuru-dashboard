# Copyright (c) 2013 tsuru authors
# Use of this source code is governed by a BSD-style license that can be found
# in the LICENSE file.

require "json"
require "net/http"

projects = [
  "tsuru",
  "gandalf",
  "tsuru-healer",
  "commandmocker",
  "config",
  "tsuru-dashboard",
  "pantera",
  "tsuru-backuper",
  "mysqlapi",
  "crane-ec2",
  "go-gandalfclient",
  "python-tsuruclient",
  "charms",
  "tsuru-circus",
  "go-openstack",
  "memcachedapi",
  "mongoapi",
  "cloudinit-centos-6",
  "juju-centos-6",
  "python-txaws-centos-6",
  "zookeeper-centos-6",
]

issues_count = Hash.new({ value: 0 })

# SCHEDULER.every "10m" do
  http = Net::HTTP.new "api.github.com", 443
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  response = http.get "/orgs/globocom/repos?per_page=100"
  repositories = JSON.parse response.body
  repositories = repositories.each do |repo|
    if projects.find {|p| p == repo["name"]} != nil
      issues_count[repo["name"]] = {label: repo["name"], value: repo["open_issues"].to_i}
    end
  end
  send_event("issues", { items: issues_count.values.sort_by {|v| -v[:value]} })
# end
