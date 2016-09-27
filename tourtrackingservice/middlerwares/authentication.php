<?php

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

function authentication($request, $response, $next) {
	$id = null;
	$password = null;
	if(isset($_SERVER['PHP_AUTH_USER'])){
		$id = $_SERVER['PHP_AUTH_USER'];
		$password = $_SERVER['PHP_AUTH_PW'];
		if(is_null($id) || is_null($password)){
			$response->getBody()->write(response_error("Invalid Authentication Header!"));
			return $response->withHeader('Content-type', 'application/json');
		}
		$db = new db();
		$tourguide_id = $db->escape_string($id);
		$access_token = $db->escape_string($password);
		$query = "SELECT * FROM tourguide WHERE tourguide_id = '$tourguide_id' AND access_token = '$access_token'";
		$user = $db->fetchRow($query);
		if($user != null){
			$response = $next($request, $response);
        	return $response;
    	}

    	$response->getBody()->write(response_error("Authentication Failure!"));
		return $response->withHeader('Content-type', 'application/json');
	}
	$response->getBody()->write(response_error("Using Basic Authentication"));
	return $response->withHeader('Content-type', 'application/json');
}