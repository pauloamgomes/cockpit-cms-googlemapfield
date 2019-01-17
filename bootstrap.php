<?php

/**
 * @file
 * Cockpit module bootstrap implementation.
 */

$this->module('googlemapsfield')->extend([

  'getConfig' => function() : array {
    return $this->app->config['google']['maps'] ?? [];
  },

]);

// Include admin.
if (COCKPIT_ADMIN && !COCKPIT_API_REQUEST) {
  include_once __DIR__ . '/admin.php';
}
