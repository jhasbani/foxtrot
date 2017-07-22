class FoxTrot.Views.ModeToggle extends Backbone.View
  template: JST['mode_toggle']

  events:
    'change input[name=mode_toggle_options]' : 'onChange'

  initialize: (options) ->
    @settings = options.settings


  render: ->
    $(@el).html(@template(@settings.attributes))
    @

  onChange: ->
    mode = @$('input:checked').val()
    @settings.set('mode', mode)
