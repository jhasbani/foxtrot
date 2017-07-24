class FoxTrot.Views.VisitToggle extends Backbone.View
  template: JST['visit_toggle']

  initialize: (options) ->
    @settings = options.settings
    @site = options.site
    @visits = options.visits

  render: ->
    visit = @visits.findWhere(site_id: @site.id)
    visited = if visit then visit.visited else false
    wished = if visit then visit.wished else false

    @$el.html( @template(visited: visited, wished: wished) )
    @

