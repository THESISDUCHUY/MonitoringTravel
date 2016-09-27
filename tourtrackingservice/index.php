<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

include ("lib/config.php");
include ("lib/db.php");
include ("lib/util.php");
include ("middlerwares/authentication.php");
include ("controllers/tourguide.php");

require 'vendor/autoload.php';

$app = new \Slim\App;

$app->post('/login', 'login');

$app->get('/tourguides/{id}', 'tourguide_info_get');
$app->get('/tourguides/{id}/tours', 'tours_info_get');
$app->get('/tours/{id}', 'tour_info_get');
$app->get('/tours/{id}/schedules', 'tour_schedules_get');
$app->get('/tours/{id}/tourists','tourists_get');
$app->get('/tours/{id}/places/location', 'places_location_get');
$app->get('/tours/{id}/tourists/location', 'tourists_location_get');
$app->get('/places/{id}','places_get');
$app->get('/managers/{id}', 'manager_info_get');
$app->put('/tourguides/{id}', 'tourguide_location_update')->add("authentication");
$app->put('/tourists/{id}', 'tourist_location_update')->add("authentication");
$app->run();