# Google Maps Addon for Cockpit CMS

This addon enhances Cockpit CMS by providing two new field types (googlemap and googlemapiframe) that can be used to handle easily google maps information.

## Installation

Download and unpack addon to `<cockpit-folder>/addons/GoogleMapsField` folder.

## Configuration

### Google API key/secret

You need to have a google map api key and configure it in config.yaml:

```yaml
google:
  maps:
    api_key: xxxxxxx_GMAPS_API_KEY_xxxxxxxxx
```

### Permissions

The field to be used by non admin users requires a permission defined at the group level, e.g.:

```yaml
groups:
  editor:
    googlemapsfield:
      access: true
```

## Usage

### Googlemap

Having a new field in your collection you only need to type something or drag the marker:

![interactive map](https://monosnap.com/image/ky2ZnnYRndDMmtq9hG0xKm5pbABM1J)

Its possible to provide extra details (e.g. marker title, infowindow text)

![Details](https://monosnap.com/image/R1GVPLCkKJpduCjEK5HqRwpv8yQPlk)

And the resulting json that can be used in the frontend:

![Map json](https://monosnap.com/image/pu6ndMMRb6L8Nob7pit9NH68An9KbU)

### Google iframe map

The field works basically as a container/validator for a google embeded url (iframe), providing the possibility to preview the url:

![Iframe Map](https://monosnap.com/image/wG3fjAKz1eEifMKpuImvaHlnGa68CP)

And the resulting field json:

![Embeded map json](https://monosnap.com/image/eYgAVRMy7HCB7jPH8FJBXyHrwNinpA)

## Copyright and license

Copyright 2019 pauloamgomes under the MIT license.
