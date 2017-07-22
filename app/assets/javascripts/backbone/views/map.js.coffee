class FoxTrot.Views.Map extends Backbone.View

  initialize: (options) ->
    @settings = options.settings
    @sites = options.sites

    @gmap = new google.maps.Map(@el, {
      zoom: 2,
      center: new google.maps.LatLng(20,0),
    })

    selected_sites = new BitArray(2048)
    selected_icon = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png'

    # Parse query string
    url = new Url
    if (url.query.map)
      selected_sites = new BitArray(2048, LZString.decompressFromEncodedURIComponent(url.query.map))
   
    infowindow = new google.maps.InfoWindow({})

    # Build a marker per site
    markers = $.map(sites, (site) ->
      icon = undefined
      if (selected_sites.get(site.site_id))
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
      google.maps.event.addListener(marker, 'click', () ->
        infowindow.setContent("<a href='#{site.url}' target='_blank'>#{site.name}</a>&nbsp;<button class='btn btn-success btn-xs toggle' data-site-id='#{site.site_id}'>Toggle</button>")
       
        # Show info window
        infowindow.open(@gmap, marker)
      )
      return marker
    )

    markerCluster = new MarkerClusterer(@gmap, markers, {ignoreHidden: true, imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'})
    # Handle toggle button within marker infowindow
    $(document).on('click', 'button.toggle', () ->
      site_id = $(this).data('site-id')
      # Find the marker (is there a much better way?)
      marker = undefined
      $.each(sites, (i, site) ->
        if (site.site_id == site_id)
          marker = site.marker
      )

      # Toggle selection state
      if (selected_sites.get(site_id))
        marker.setIcon(undefined)
        selected_sites.set(site_id, false)
      else
        marker.setIcon(selected_icon)
        selected_sites.set(site_id, true)
      
      # Update Url String
      url = new Url
      url.query.map = LZString.compressToEncodedURIComponent(selected_sites.toHexString())
      window.history.replaceState(undefined, 'Unesco Map', url.toString())
    )

    # Toggle edit mode
    $('#edit_mode').change( () ->
      infowindow.close()
      # In RO mode, hide unselected markers
      $.each(markers, (i, marker) ->
        marker.setVisible(editMode() || selected_sites.get(marker.site.site_id))
      )
      markerCluster.repaint()
    )
    $('#edit_mode').change()
 
