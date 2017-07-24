class FoxTrot.Views.SiteListingEntry extends Backbone.View
  template: JST['site_listing_entry']
  tagName: 'tr'

  events:
    'click a.name' : 'selectSite'

  initialize: (options) ->
    @settings = options.settings
    @site = options.site
    @visits = options.visits

    @listenTo(@settings, 'change:mode', @onModeChange)
    @listenTo(Backbone, 'foxtrot:map:select', @onMapSelect)

  render: ->
    @$el.html( @template(@site) )

    (new FoxTrot.Views.VisitToggle(el: @$('.js-replace-visit-toggle'), site: @site, visits: @visits)).render()

    @onModeChange()
    @

  selectSite: (e) ->
    e.preventDefault()
    e.stopPropagation()

    Backbone.trigger('foxtrot:sitelisting:select', @site)

  onModeChange: ->
    # TODO: hide/show entry depending on mode.
    mode = @settings.get('mode')
    if mode == 'all'
      @$el.show()
    else
      visit = @visits.findWhere(site_id: @site.id)
      unless visit
        @$el.hide()
        return
      if (mode == 'visited' and visit.visisted) or (mode == 'wished' and visit.wished)
        @$el.show()
      else
        @$el.hide()


  onMapSelect: (site) ->
    if site.id != @site.id
      return

    table = @$el.closest('table')
    table.parent().scrollTop( @$el.position().top - @$el.parent().children(':first').position().top )
