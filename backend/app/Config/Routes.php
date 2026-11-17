<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');

$routes->group('api', ['namespace' => 'App\Controllers\Api', 'filter' => 'cors'], static function ($routes) {
    $routes->options('(:any)', static function () {
    });
    $routes->resource('umkm', ['controller' => 'UmkmController', 'except' => 'new,edit']);
});