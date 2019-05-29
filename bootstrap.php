<?php

/**
 * @file
 * Cockpit module bootstrap implementation.
 */

// Include admin.
if (COCKPIT_ADMIN && !COCKPIT_API_REQUEST) {
  $this->module('googlemapsfield')->extend([
    'getConfig' => function() : array {
      return $this->app->config['google']['maps'] ?? [];
    },
  ]);

  include_once __DIR__ . '/admin.php';
}
