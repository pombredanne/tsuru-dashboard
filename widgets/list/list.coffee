# Copyright (c) 2013 Shopify
# Use of this source code is governed by a MIT-style license that can be found
# in the LICENSE file.

class Dashing.List extends Dashing.Widget
  ready: ->
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()
