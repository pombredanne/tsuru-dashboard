# Copyright (c) 2013 Shopify
# Use of this source code is governed by a MIT-style license that can be found
# in the LICENSE file.

# Populate the graph with some random points
points = []
(1..10).each do |i|
  points << { x: i, y: rand(50) }
end
last_x = points.last[:x]

SCHEDULER.every '2s' do
  points.shift
  last_x += 1
  points << { x: last_x, y: rand(50) }

  send_event('convergence', points: points)
end
