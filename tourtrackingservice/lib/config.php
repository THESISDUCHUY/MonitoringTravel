<?php
define ('DB_HOST',           'localhost');
define ('DB_USER_NAME',      'root');
define ('DB_PASSWORD',       '');
define ('DB_NAME',           'tourtracking');

class ResponseCode {
	static $OK = 200; // success status
	static $CREATED = 201; //success ceation occurred
	static $NO_CONTENT = 204;
	static $BAD_REQUEST = 400; //invalid request, miss data
	static $UNAUTHORIZED = 401;//invalid authentication token
	static $FORBIDDEN = 403; //
	static $NOT_FOUND = 404; //resources not found
}

class TourStatus{
	static $START = "start";
	static $RUNNING = "running";
	static $FINISHED = "finished";
}