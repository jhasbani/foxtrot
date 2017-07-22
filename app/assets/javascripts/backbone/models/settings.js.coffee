class FoxTrot.Models.Settings extends Backbone.Model
  DEFAULTS:
    mode: 'all'

  initialize: (settings = {}) ->
    @set(_.extend(@DEFAULTS, settings))
