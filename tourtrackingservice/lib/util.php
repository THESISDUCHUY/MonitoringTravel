<?php

function make_response($error_code, $message = '', $data = null) {
    return json_encode(
            array(
                'error_code' => $error_code,
                'message' => $message,
                'data' => $data
    ));
}

function response_success($data = null){
    return json_encode(
            array(
                'status' => "success",
                'data'=> $data
                ));
}
function response_error($message){
        return json_encode(
            array(
                'status' => "error",
                'message'=> $message
                ));
}

function createAccesstoken() {
	$length = 32;
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return md5($randomString);
}

function response_json($json){
    header('Content-Type: application/json');
    echo $json;
    exit;
}