<?php

 //use \Psr\Http\Message\ServerRequestInterface as Request;
 //use \Psr\Http\Message\ResponseInterface as Response;

function login($request, $response){
	if(!isset($_POST['phone']) || !isset($_POST['password'])){
		$response->getBody()->write(response_error('Data Invalid!'));
		return $response->withHeader('Content-type', 'application/json');
	}
	$db = new db();
	$phone = $db->escape_string($_POST['phone']);
	$password = $db->escape_string($_POST['password']);

	//check touguide login
	$query = "SELECT tourguide_id, access_token FROM tourguide WHERE  phone = '$phone' and password = '$password'";
	$tourguide = $db->fetchRow($query);
	if($tourguide != null){
		$response_data = array('tourguide_id'=>$tourguide['tourguide_id'],
								'access_token'=>$tourguide['access_token']);
		$response->getBody()->write(response_success($response_data));
		return $response->withHeader('Content-type', 'application/json');
	}
	else{
		$response->getBody()->write(response_error('Tai khoan hoac mat khau khong dung!'));
		return $response->withHeader('Content-type', 'application/json');	
	}
}

function tourguide_info_get($request, $response, $args){
	$db = new db();
	$tourguide_id = $args['id'];//$db->escape_string($request->getAttribute('id'));

	$query = "SELECT * FROM tourguide WHERE tourguide_id = '$tourguide_id'";
	$tourguide = $db->fetchRow($query);
	if($tourguide != null){
		$response_data = array(	'tourguide_name'=>$tourguide['tourguide_name']
								, 'phone'=>$tourguide['phone']
								, 'display_photo'=>$tourguide['display_photo']); 
		$response->getBody()->write(response_success($response_data));
		return $response->withHeader('Content-type', 'application/json');
	}
	$response->getBody()->write(response_error('Tourguide Not Found'));
	return $response->withHeader('Content-type', 'application/json');
}

function manager_info_get($request, $response, $args){
	$manager_id = $args['id'];
	$db = new db();
	$query = "SELECT manager_name, email, phone_number, display_photo, position FROM manager WHERE manager_id = '$manager_id'";
	$manager = $db->fetchRow($query);
	if($manager != null){
		$response_data = array('manager_name'=>$manager['manager_name']
								, 'email'=>$manager['email']
								, 'phone_number'=>$manager['phone_number']
								, 'position'=>$manager['position']
								, 'display_photo'=>$manager['display_photo']);
		$response->getBody()->write(response_success($response_data));
		return $response->withHeader('Content-type', 'application/json');
	}
	$response->getBody()->write(response_error('Manager Not Found'));
	return $response->withHeader('Content-type', 'application/json');
}
function tour_info_get($request, $response, $args){
	$tour_id = $args['id'];
	$db = new db();
	$query = "SELECT * FROM tour WHERE tour_id = '$tour_id'";
	$tour = $db->fetchRow($query);
	if($tour != null){
		$response_data = array( 'manager_id'=>$tour['manager_id']
									, 'tour_code'=>$tour['tour_code']
									, 'tour_name'=>$tour['tour_name']
									, 'tour_quantity'=>intval($tour['tourist_quantity'])
									, 'status'=>$tour['status']
									, 'departure_date'=>$tour['departure_date']
									, 'return_date'=>$tour['return_date']
									, 'description'=>$tour['description']
									, 'cover_photo'=>$tour['cover_photo']
									);
		$response->getBody()->write(response_success($response_data));
		return $response->withHeader('Content-type', 'application/json');
	}
	$response->getBody()->write(response_error('Tour Not Found'));
	return $response->withHeader('Content-type', 'application/json');
}
function tours_info_get($request, $response, $args){

	$tourguide_id = $args['id'];
	$status1 = TourStatus::$START;
	$status2 = TourStatus::$RUNNING;
	
	$db = new db();
	$query = "SELECT * FROM tour WHERE (tourguide_id = '$tourguide_id' AND status = '$status1') OR (tourguide_id = '$tourguide_id' AND status = '$status2')";
	$tours = $db->query($query);
	//if($tours->num_rows > 0){
		$response_data = null;
		while($tour = $tours->fetch_assoc()){
			$response_data[] = array( 'manager_id'=>$tour['manager_id']
									, 'tour_code'=>$tour['tour_code']
									, 'tour_name'=>$tour['tour_name']
									, 'tour_quantity'=>intval($tour['tourist_quantity'])
									, 'status'=>$tour['status']
									, 'departure_date'=>$tour['departure_date']
									, 'return_date'=>$tour['return_date']
									, 'description'=>$tour['description']
									, 'cover_photo'=>$tour['cover_photo']
									);
		}
		$response->getBody()->write(response_success($response_data));
		return $response->withHeader('Content-type', 'application/json');	
	//}
	//$response->getBody()->write(response_error('Không tìm thấy tour!'));
	//return $response->withHeader('Content-type', 'application/json');	
}

function tour_schedules_get($request, $response, $args){
	if(!isset($args['id'])){
		$response->getBody()->write(response_error('Invalid'));
		return $response->withHeader('Content-type', 'application/json');	
	}
	$db = new db();
	$tour_id = $args['id'];//$db->escape_string($request->getAttribute('tour_id'));
	$query = "SELECT * FROM tour_schedule WHERE tour_id = '$tour_id'";
	$schedules = $db->query($query);

	while($schedule = $schedules->fetch_assoc()){
		$response_data[] = array('place_id'=>$schedule['place_id']
			, 'place_name'=>$schedule['place_']
			,'vehicle'=>$schedule['vehicle']
			,'time'=>$schedule['time']
			,'description'=>$schedule['description']);
	}
	$response->getBody()->write(response_success($response_data));
	return $response->withHeader('Content-type', 'application/json');
}
function places_get($request, $response, $args){
	$db = new db;
	$place_id = $args['id'];
	$query = "SELECT * FROM place WHERE place_id = '$place_id'";
	$place = $db->fetchRow($query);
	//var_dump($place);return;
	if($place != null){
		$response_data = array('place_id'=>$place['place_id']
			 					, 'province_id'=>intval($place['province_id'])
			 					, 'place_name'=>$place['place_name']
			 					, 'contact'=>$place['contact']
			 					, 'address'=>$place['address']
			 					, 'cover_photo'=>$place['cover_photo']
			 					, 'latitude'=>doubleval($place['latitude'])
			 					, 'logitude'=>doubleval($place['longitude']));
		$response->getBody()->write(response_success($response_data));
		return $response->withHeader('Content-type', 'application/json');
	}
	$response->getBody()->write(response_error('Place is not found'));
	return $response->withHeader('Content-type', 'application/json');
}

function tourists_get($request, $response, $args){
	$db = new db();
	$tour_id = $args['id'];
	$query = "SELECT tourist_id FROM tour_participants WHERE tour_id = '$tour_id'";
	$participants = $db->query($query);
	
	if($participants->num_rows > 0){
		$response_data = null;
		while($participant = $participants->fetch_assoc()){
			$tourist_id = $participant['tourist_id'];
			$query_tourist = "SELECT * FROM tourist WHERE tourist_id = '$tourist_id'";
			$tourist = $db->fetchRow($query_tourist);
			if($tourist != null){
				$response_data[] = array('tourist_id' =>intval($tourist['tourist_id'])
										  	,'tourist_name'=>$tourist['tourist_name']
										  	, 'phone'=>$tourist['phone']
										  	, 'email'=>$tourist['email']
										  	, 'display_photo'=>$tourist['display_photo']);
			}	
		}
		$response->getBody()->write(response_success($response_data));
		return $response->withHeader('Content-type', 'application/json');
	}
	$response->getBody()->write(response_error('Không có du khách tham gia'));
	return $response->withHeader('Content-type', 'application/json');

}

function tourists_location_get($request, $response, $args){
	$db = new db();
	$tour_id = $args['id'];
	$query = "SELECT tourist_id FROM tour_participants WHERE tour_id = '$tour_id'";
	$participants = $db->query($query);
	
	if($participants->num_rows > 0){
		$response_data = null;
		while($participant = $participants->fetch_assoc()){
			$tourist_id = $participant['tourist_id'];
			$query_tourist = "SELECT * FROM tourist WHERE tourist_id = '$tourist_id'";
			$tourist = $db->fetchRow($query_tourist);
			if($tourist != null){
				$response_data[] = array('tourist_id' =>intval($tourist['tourist_id'])
										  	,'latitude'=>$tourist['latitude']
										  	, 'longitude'=>$tourist['longitude']);
			}	
		}
		$response->getBody()->write(response_success($response_data));
		return $response->withHeader('Content-type', 'application/json');
	}
	$response->getBody()->write(response_error('Không có du khách tham gia'));
	return $response->withHeader('Content-type', 'application/json');

}
function tourguide_location_update($request, $response, $args){

	//check params valid
	$params = $request->getparams();
	if(!isset($params['latitude']) || !isset($params['longitude'])){
		$response->getBody()->write(response_error('Params Invalid'));
		return $response->withHeader('Content-type', 'application/json');
	}
	$tourguide_id = $args['id'];
	$latitude = $params['latitude'];
	$longitude = $params['longitude'];
	
	//update db
	$db = new db();
	$query = "UPDATE tourguide SET latitude = '$latitude', longitude = '$longitude' WHERE tourguide_id = '$tourguide_id'";
	$result = $db->query($query);
	if($result){
		$response->getBody()->write(response_success(null));
		return $response->withHeader('Content-type', 'application/json');
	}
	$response->getBody()->write(response_error('Update DB Failure'));
	return $response->withHeader('Content-type', 'application/json');
}

function tourist_location_update($request, $response, $args){
	//check params valid
	$params = $request->getparams();
	if(!isset($params['latitude']) || !isset($params['longitude'])){
		$response->getBody()->write(response_error('Params Invalid'));
		return $response->withHeader('Content-type', 'application/json');
	}
	$tourist_id = $args['id'];
	$latitude = $params['latitude'];
	$longitude = $params['longitude'];
	
	//update db
	$db = new db();
	$query = "UPDATE tourist SET latitude = '$latitude', longitude = '$longitude' WHERE tourist_id = '$tourist_id'";
	$result = $db->query($query);
	if($result){
		$response_data = null;
		$query = 'SELECT latitude, longitude FROM tourist WHERE ';
		$response->getBody()->write(response_success(null));
		return $response->withHeader('Content-type', 'application/json');
	}
	$response->getBody()->write(response_error('Update DB Failure'));
	return $response->withHeader('Content-type', 'application/json');
}

function places_location_get($request, $response, $args){
	$tour_id = $args['id'];
	$db = new db();
	$tour_id = $args['id'];//$db->escape_string($request->getAttribute('tour_id'));
	$query = "SELECT * FROM tour_schedule WHERE tour_id = '$tour_id'";
	$schedules = $db->query($query);
	$response_data = null;
	while($schedule = $schedules->fetch_assoc()){
		$place_id = $schedule['place_id'];
		$query = "SELECT latitude, longitude FROM place WHERE place_id = '$place_id'";
		$place = $db->fetchRow($query);
		if($place != null){
			$response_data[] = array('place_id'=>$place_id
										, 'latitude'=>$place_id['latitude']
										, 'longitude'=>$place_id['longitude']);
		}
	}
	$response->getBody()->write(response_success($response_data));
	return $response->withHeader('Content-type', 'application/json');
}