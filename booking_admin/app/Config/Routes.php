<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */

// Auth Routes
$routes->get('/', 'Auth::login');
$routes->get('login', 'Auth::login');
$routes->post('login', 'Auth::attemptLogin');
$routes->get('logout', 'Auth::logout');

// Dashboard
$routes->get('dashboard', 'Dashboard::index', ['filter' => 'auth']);

// Users CRUD
$routes->group('users', ['filter' => 'auth'], static function ($routes) {
    $routes->get('/', 'Users::index');
    $routes->get('create', 'Users::create');
    $routes->post('store', 'Users::store');
    $routes->get('edit/(:num)', 'Users::edit/$1');
    $routes->post('update/(:num)', 'Users::update/$1');
    $routes->get('delete/(:num)', 'Users::delete/$1');
});

// Routes CRUD
$routes->group('routes', ['filter' => 'auth'], static function ($routes) {
    $routes->get('/', 'Routes::index');
    $routes->get('create', 'Routes::create');
    $routes->post('store', 'Routes::store');
    $routes->get('edit/(:num)', 'Routes::edit/$1');
    $routes->post('update/(:num)', 'Routes::update/$1');
    $routes->get('delete/(:num)', 'Routes::delete/$1');
});

// Schedules CRUD
$routes->group('schedules', ['filter' => 'auth'], static function ($routes) {
    $routes->get('/', 'Schedules::index');
    $routes->get('create', 'Schedules::create');
    $routes->post('store', 'Schedules::store');
    $routes->get('edit/(:num)', 'Schedules::edit/$1');
    $routes->post('update/(:num)', 'Schedules::update/$1');
    $routes->get('delete/(:num)', 'Schedules::delete/$1');
});

// Passengers CRUD
$routes->group('passengers', ['filter' => 'auth'], static function ($routes) {
    $routes->get('/', 'Passengers::index');
    $routes->get('create', 'Passengers::create');
    $routes->post('store', 'Passengers::store');
    $routes->get('edit/(:num)', 'Passengers::edit/$1');
    $routes->post('update/(:num)', 'Passengers::update/$1');
    $routes->get('delete/(:num)', 'Passengers::delete/$1');
});

// Bookings CRUD
$routes->group('bookings', ['filter' => 'auth'], static function ($routes) {
    $routes->get('/', 'Bookings::index');
    $routes->get('create', 'Bookings::create');
    $routes->post('store', 'Bookings::store');
    $routes->get('edit/(:num)', 'Bookings::edit/$1');
    $routes->post('update/(:num)', 'Bookings::update/$1');
    $routes->get('delete/(:num)', 'Bookings::delete/$1');
    $routes->get('detail/(:num)', 'Bookings::detail/$1');
});

// Payments CRUD
$routes->group('payments', ['filter' => 'auth'], static function ($routes) {
    $routes->get('/', 'Payments::index');
    $routes->get('create', 'Payments::create');
    $routes->post('store', 'Payments::store');
    $routes->get('edit/(:num)', 'Payments::edit/$1');
    $routes->post('update/(:num)', 'Payments::update/$1');
    $routes->get('delete/(:num)', 'Payments::delete/$1');
});
