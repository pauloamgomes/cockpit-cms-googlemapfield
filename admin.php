<?php

/**
 * @file
 * Cockpit GoogleMapField admin functions.
 */

// Module ACL definitions.
$this("acl")->addResource('googlemapsfield', [
  'access',
]);

/**
 * Initialize addon for admin pages.
 */
$app->on('admin.init', function () use ($app) {
  // Add google map field.
  $this->helper('admin')->addAssets('googlemapsfield:assets/field-googlemapiframe.tag');
  $this->helper('admin')->addAssets('googlemapsfield:assets/field-googlemap.tag');
});


