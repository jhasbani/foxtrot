class FoxTrot.Views.Map extends Backbone.View

  initialize: (options) ->
    @settings = options.settings
    @sites = options.sites
    @visits = options.visits

    @gmap = new google.maps.Map(@el, {
      zoom: 2,
      center: new google.maps.LatLng(20,0),
    })

    # TODO: set window to contain all markers.

    selected_icon = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png'

    @infowindow = new google.maps.InfoWindow({})

    # Build a marker per site
    @markers = $.map(sites, (site) =>
      icon = undefined

      # TODO: set the icon depending on visit/wish state
      visit = @visits.findWhere(site_id: site.id)
      if visit and visit.visited
        icon = selected_icon

      latLng = new google.maps.LatLng(site.latitude, site.longitude)
      marker = new google.maps.Marker({
        position: latLng,
        map: @gmap,
        icon: icon
      })

      # cross reference
      marker.site = site
      site.marker = marker

      # Bind click on marker event
      google.maps.event.addListener(marker, 'click', () =>
        @showMarkerInfo(marker)
        Backbone.trigger('foxtrot:map:select', marker.site)
      )
      return marker
    )

    @markerCluster = new MarkerClusterer(@gmap, @markers, {ignoreHidden: true, imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'})

    @listenTo(Backbone, 'foxtrot:sitelisting:select', @selectSite)
    @listenTo(@settings, 'change:mode', @redraw)
    @redraw()

  # In reaction to a display mode change, redraw the markers.
  redraw: =>
    if (@visitToggle)
      @visitToggle.remove()
      @visitToggle = undefined
    @infowindow.close()

    @updateMarkers()

  updateMarkers: =>
    # show markers that match the mode.

    mode = @settings.get('mode')
    $.each(@markers, (i, marker) =>
      visable = false
      if mode == 'all'
        visable = true
      else
        visit = @visits.findWhere(site_id: marker.site.id)
        if visit and ((mode == 'visited' and visit.visted) or (mode == 'wished' and visit.wished))
          visable = true
      marker.setVisible(visable)
    )
    @markerCluster.repaint()
    

  # Display the tooltip for the site.
  showMarkerInfo: (marker) =>
    site = marker.site

    if (@visitToggle)
      @visitToggle.remove()
      @visitToggle = undefined
    @infowindow.close()

    @infowindow.setContent("<a href='#{site.url}' target='_blank'>#{site.name}</a>&nbsp;<span class='js-replace-visit-toggle'></span>")
       
    # Show info window
    @infowindow.open(@gmap, marker)
    @infowindow.setPosition(marker.getPosition())

    unless @settings.get('readonly')
      (new FoxTrot.Views.VisitToggle(el: $('.js-replace-visit-toggle'), settings: @settings, site: site, visits: @visits)).render()
    

  # In reaction to a click in the list, set the selected site.
  selectSite: (site) =>
    @showMarkerInfo(site.marker)

    @gmap.panTo(site.marker.getPosition())

    @gmap.setZoom(4)
    @markerCluster.repaint()

    @marker = site.marker
    @zoomToMarker()

  # Zoom the map until the marker isn't clustered.
  zoomToMarker: =>
    zoom = @gmap.getZoom()
    return if zoom == 20
    return unless @markerIsClustered(@marker)

    @gmap.setZoom(++zoom)
    @markerCluster.repaint()

    # Need to step out of the way for the redraw to occur.
    setTimeout(@zoomToMarker, 0)

  # Determine if the marker is part of a cluster of more than 1.
  markerIsClustered: (marker) =>
    clusters = @markerCluster.getClusters()
    clen = clusters.length
    return unless clen > 0
    for i in [0..clen]
      mlen = clusters[i].markers_.length
      for j in [0..mlen]
        if clusters[i].markers_[j] == marker
          return mlen > 1
    return false
      
