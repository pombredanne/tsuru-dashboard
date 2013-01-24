# Copyright (c) 2013 Shopify
# Use of this source code is governed by a MIT-style license that can be found
# in the LICENSE file.

class Dashing.Iframe extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
