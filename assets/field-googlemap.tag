<field-googlemap>

  <div class="uk-grid">

    <div class="uk-margin uk-width-3-4">
      <label>{ App.i18n.get('Address') }</label>
      <field-text id="address" bind="value.address" value="{ value.address }" maxlength="120" />
    </div>

    <div class="uk-margin uk-width-1-4">
      <button onclick="{viewOptions}" class="uk-button uk-button-large uk-button-secondary uk-margin-right"><i class="uk-icon-cog"></i> Settings</button>
    </div>

    <div class="uk-panel uk-width-1-1">
      <div id="{mapId}" class="gmap" style="height: 400px; border: 1px solid #ccc"></div>
      <label><span class="uk-text-bold">Latitude:</span> {value.lat} <span class="uk-text-bold">Longitude:</span> {value.lng}</label>
    </div>

    <div class="uk-modal uk-modal-map uk-height-viewport">
      <div class="uk-modal-dialog">
        <a href="" class="uk-modal-close uk-close"></a>
        <strong>{App.i18n.get('Map Options')}</strong>
        <div class="uk-margin uk-grid">
          <div class="uk-width-medium-1-1">
            <div>
              <label>{ App.i18n.get('Map Header') }</label>
              <field-text bind="value.header" class="uk-width-1-1" value="{ value.header }" maxlength="160" />
            </div>
          </div>
          <div class="uk-margin-top  uk-width-medium-1-1">
            <div>
              <label>{ App.i18n.get('Marker title') }</label>
              <field-text bind="value.marker.title" class="uk-width-1-1" value="{ value.marker.title }" maxlength="160" />
            </div>
          </div>
          <div class="uk-margin-top uk-width-medium-1-1">
            <div>
              <label>{ App.i18n.get('Marker text (infowindow)') }</label>
              <field-wysiwyg bind="value.marker.text" editor={{"format": "Basic"}} class="uk-width-1-1" value="{ value.marker.text }" rows="2" />
            </div>
          </div>
          <div class="uk-width-medium-1-1 uk-margin-top">
            <label>{ App.i18n.get('Options') }</label>
          </div>
          <div class="uk-width-medium-1-2 uk-margin-top">
            <field-boolean bind="value.options.controls" title="Display Controls" label="Display Controls"></field-boolean>
          </div>
          <div class="uk-width-medium-1-2 uk-margin-top">
            <field-boolean bind="value.options.marker" title="Display Marker" label="Display Marker"></field-boolean>
          </div>
          <div class="uk-width-medium-1-3 uk-margin-top">
            <div class="uk-margin-top">
              <label>{ App.i18n.get('Map Height') }</label>
              <field-text bind="value.options.height" type="number" step="50" min="100" max="1000" title="Map Height" label="Map Height"></field-text>
            </div>
          </div>
          <div class="uk-width-medium-1-3 uk-margin-top">
            <div class="uk-margin-top">
              <label>{ App.i18n.get('Map type') }</label>
              <field-select bind="value.options.type" options="{'roadmap,satellite,hybrid'}" title="Map Type" label="Map Type"></field-select>
            </div>
          </div>
          <div class="uk-width-medium-1-3 uk-margin-top">
            <div class="uk-margin-top">
              <label>{ App.i18n.get('Map default zoom') }</label>
              <field-select bind="value.options.zoom" options="{'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21'}" title="Zoom Level" label="Zoom Level"></field-text>
            </div>
          </div>
        </div>
      </div>
    </div>

  </div>

  <script>
    var $this = this;
    this.mixin(RiotBindMixin);

    $this.mapId = "map-" + opts.bind;

    this.value = {
      'header': '',
      'address': '',
      'lat': 39.487385,
      'lng': -9.419772,
      'marker': {
        'title': '',
        'text': '',
      },
      'options': {
        'controls': true,
        'zoom': '9',
        'type': 'roadmap',
        'height': 400,
        'marker': true
      }
    };

    this.on('mount', function() {

      (['controls', 'zoom', 'type', 'height', 'marker']).forEach(function(key) {
        if (key in opts) {
          $this.value.options[key] = opts[key];
        }
      });

      App.callmodule('googlemapsfield:getConfig', {}).then(function(data) {
        if (data.result && data.result.api_key) {
          $this.api_key = data.result.api_key;
          $this.loadScript('//maps.googleapis.com/maps/api/js?key=' + $this.api_key + '&libraries=places').then(function() {
              $this.apiready = true;
              setTimeout(function() {
                $this.map = new google.maps.Map(document.getElementById($this.mapId), {
                  center: {lat: $this.value.lat, lng: $this.value.lng},
                  zoom: 1
                });
                google.maps.event.addListener($this.map, 'click', function(event) {
                  $this.placeMarker(event.latLng, $this.map);
                });
                var input = App.$('#address').find('input')[0];
                var autocomplete = new google.maps.places.Autocomplete(input, {});
                google.maps.event.addListener(autocomplete, 'place_changed', function() {
                  var place = autocomplete.getPlace();
                  if (place && place.geometry) {
                    $this.placeMarker(place.geometry.location, $this.map);
                    $this.map.setZoom(9);
                  }
                });
                $this.geocoder = new google.maps.Geocoder();
                new google.maps.Geocoder();
              }, 50);
              $this.modal = UIkit.modal(App.$('.uk-modal-map', this.root), {modal:true});
              $this.update();
          });
        } else {
          App.ui.notify(App.i18n.get("Google Maps api_key not configured"), "danger");
        }
      });
    });

    this.on('bindingupdated', function() {
      $this.$setValue(this.value);
    });

    this.$updateValue = function(value, field) {
      if (value) {
        this.value = value;
      }
      this.update();
    }.bind(this);

    viewOptions(e) {
      e.preventDefault();
      $this.modal.show();
      return false;
    }

    $this.loadScript = function(url) {
      return new Promise(function(resolve, reject) {
        var script = document.createElement('script');

        script.async = true;

        script.onload = function() {
            resolve(url);
        };

        script.onerror = function() {
            reject(url);
        };

        script.src = url;

        document.getElementsByTagName('head')[0].appendChild(script);
      });
    }

    $this.handleMarkerDragEvent = function(event) {
      $this.value.lat = event.latLng.lat();
      $this.value.lng = event.latLng.lng();
      $this.update();
    }

    $this.handleMarkerDragEndEvent = function(event) {
      $this.value.lat = event.latLng.lat();
      $this.value.lng = event.latLng.lng();
      $this.geocoder.geocode({'latLng': event.latLng}, function(results, status) {
        if (status && status === "OK" && results) {
          $this.value.address = results[0].formatted_address;
        } else {
          $this.value.address = "";
        }
        $this.update();
      });
    }

    $this.placeMarker = function(location, map) {
      if ($this.marker && $this.marker.setMap) {
        $this.marker.setMap(null);
      }
      $this.marker = new google.maps.Marker({
        draggable: true,
        position: location,
        map: map
      });
      map.panTo(location);
      $this.marker.addListener('drag', $this.handleMarkerDragEvent);
      $this.marker.addListener('dragend', $this.handleMarkerDragEndEvent);
      $this.value.lat = location.lat();
      $this.value.lng = location.lng();

      $this.geocoder.geocode({'latLng': location}, function(results, status) {
        if (status && status === "OK" && results) {
          $this.value.address = results[0].formatted_address;
        } else {
          $this.value.address = "";
        }
        $this.update();
      });

      $this.update();
    }

  </script>

</field-googlemap>
