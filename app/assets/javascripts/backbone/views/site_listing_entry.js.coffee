class FoxTrot.Views.SiteListingEntry extends Backbone.View
  template: JST['site_listing_entry']
  tagName: 'tr'

  events:
    'click a.name' : 'selectSite'

  initialize: (options) ->
    @settings = options.setting
    @site = options.site

    @listenTo(Backbone, 'foxtrot:map:select', @onMapSelect)

  render: ->
    @$el.html( @template(@site) )    

    @

  selectSite: (e) ->
    e.preventDefault()
    e.stopPropagation()

    Backbone.trigger('foxtrot:sitelisting:select', @site)


  onMapSelect: (site) ->
    if site.id != @site.id
      return

    table = @$el.closest('table')
    table.parent().scrollTop( @$el.position().top - @$el.parent().children(':first').position().top )
