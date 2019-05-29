<field-googlemapiframe>

  <div class="uk-grid">

    <div class="uk-margin uk-width-1-1">
      <label>{ App.i18n.get('Address') }</label>
      <field-text id="url" bind="value.url" value="{ value.url }" maxlength="255" placeholder="iframe url, e.g. https://www.google.com/maps/d/embed?mid=1QIWiTa2vcAlgTZJMx0bJsJqyBRY" />
    </div>

    <div class="uk-margin uk-width-1-3">
      <label>{ App.i18n.get('Iframe Width (optional)') }</label>
      <field-text id="url" bind="value.width" value="{ value.width }" maxlength="20" />
    </div>

    <div class="uk-margin uk-width-1-3">
      <label>{ App.i18n.get('Iframe Height (optional)') }</label>
      <field-text id="url" bind="value.height" value="{ value.height }" type="number" step="50" min="380" max="1024" maxlength="20" />
    </div>

    <div class="uk-margin uk-width-1-3">
      <button show="{!previewActive}" ref="previewMapButton" onclick="{ togglePreview }" class="uk-button uk-button-large uk-button-secondary uk-margin-right"><i class="uk-icon-eye"></i> Preview Map</button>
      <button show="{previewActive}" ref="previewMapButton" onclick="{ untogglePreview }" class="uk-button uk-button-large uk-button-secondary uk-margin-right"><i class="uk-icon-close"></i> Hide Map</button>
    </div>

    <div class="uk-width-1-1" if="{previewActive}">
      <iframe style="max-width:100%; max-height:480px;" src="{value.url}" width="{value.width || 800}" height="{value.height || 400}" frameborder="0" style="border:0" allowfullscreen></iframe>
    </div>

  </div>

  <script>
    var $this = this;
    this.mixin(RiotBindMixin);

    $this.mapId = "map-" + opts.bind;

    this.value = {
      'url': '',
      'width': '100%',
      'height': '480'
    };

    this.previewActive = false;

    this.on('mount', function() {

      (['url', 'width', 'height']).forEach(function(key) {
        if (key in opts) {
          $this.value.options[key] = opts[key];
        }
      });

      $this.modal = UIkit.modal(App.$('.uk-modal-map', this.root), {modal:true});

      this.update();
    });

    this.on('bindingupdated', function() {
      if (this.value && this.value.width && parseInt(this.value.width) > 1024) {
        this.value.width = 1024;
      }
      if (this.value && this.value.width && parseInt(this.value.height) > 800) {
        this.value.height = 800;
      }
      $this.$setValue(this.value);
    });

    this.$updateValue = function(value, field) {
      if (value) {
        this.value = value;
      }
      this.update();
    }.bind(this);

    togglePreview(e) {
      e.preventDefault();
      url = $this.value.url;
      if (!url || !(/^(http:|https:)?\/\/(www|maps|)\.?google\.[a-z\.]+\/maps.*$/).test(url)) {
        App.ui.notify(App.i18n.get("The iFrame google map URL is invalid!"), "danger");
        $this.previewActive = false;
      } else {
        $this.previewActive = true;
      }
      return false;
    }

    untogglePreview(e) {
      e.preventDefault();
      $this.previewActive = false;
      return false;
    }

  </script>

</field-googlemapiframe>
