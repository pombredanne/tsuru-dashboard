# Copyright (c) 2013 tsuru authors
# Use of this source code is governed by a BSD-style license that can be found
# in the LICENSE file.

require "json"
require "net/http"

projects = [
  "abyss",
  "charms",
  "cloudinit-centos-6",
  "commandmocker",
  "config",
  "crane-ec2",
  "dr-fritz",
  "elastic-search-api",
  "gandalf",
  "go-gandalfclient",
  "go-openstack",
  "homebrew-tsuru",
  "juju-centos-6",
  "juju-status-page",
  "memcachedapi",
  "mongoapi",
  "mysqlapi",
  "pantera",
  "python-tsuruclient",
  "python-txaws-centos-6",
  "redisapi",
  "tsuru",
  "tsuru-backuper",
  "tsuru-beta-registration",
  "tsuru-circus",
  "tsuru-django-sample",
  "tsuru-dashboard",
  "tsuru-healer",
  "tsuru-service-cassandra",
  "varnishapi",
  "zookeeper-centos-6",
]

def items(projects)
  issues_count = Hash.new({ value: 0 })
  http = Net::HTTP.new "api.github.com", 443
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  response = http.get "/orgs/globocom/repos?per_page=100"
  repositories = JSON.parse response.body
  repositories = repositories.each do |repo|
    if projects.find {|p| p == repo["name"]} != nil
      if !repo["open_issues"]
        return
      end
      count = repo["open_issues"].to_i
      if count > 0
        issues_count[repo["name"]] = {label: repo["name"], value: count}
      end
    end
  end
  issues_count.values.sort_by {|v| -v[:value]}
end

send_event("issues", { items: items(projects) })
SCHEDULER.every "10m" do
  send_event("issues", { items: items(projects) })
end
