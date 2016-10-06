 var marker, map;
var listMarker = new Array();
var longfake = 0.0000000001;
var lagfake = 0.0000000001
var listPosition = [];
var listInforwindow = [];

var pinColor = "FE7569";
var pinColorSelect = "1FB5AD"

var pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor,
    new google.maps.Size(21, 34),
    new google.maps.Point(0, 0),
    new google.maps.Point(10, 34));

var pinImageSelect = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColorSelect,
    new google.maps.Size(21, 34),
    new google.maps.Point(0, 0),
    new google.maps.Point(10, 34));
    
//var pinShadow = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow",
//    new google.maps.Size(40, 37),
//    new google.maps.Point(0, 0),
//    new google.maps.Point(12, 35));


//var iconImageSelect = {
//    url: "http://localhost:20261/Content/Images/ic_marke.png", // url
//    scaledSize: new google.maps.Size(50, 59), // scaled size
//    anchor: new google.maps.Point(25, 30) // anchor
//};

//var iconImage = {
//    url: "http://localhost:20261/Content/Images/ic_marke.png", // url
//    scaledSize: new google.maps.Size(50, 59), // scaled size
//    anchor: new google.maps.Point(0, 49) // anchor

//};

function initialize() {
    var myLatlng = new google.maps.LatLng(10.824638, 106.627733);
    var mapOptions = {
        zoom: 4,
        center: myLatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);
    google.maps.event.addListener(marker, 'click', function () {
        infowindow.open(map, marker);
    });
}
function LoadMarker() {
    $.ajax({
        url: "/Home/CreateMarker/",
        type: "GET",
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        async: true,
        processData: false,
        cache: false,
        success: function (result) {
            var results = $.parseJSON(result);
            $(results).each(function (index, value) {
                var longitude = this['longitude'];
                var laitude = this['latitude'];
                var title = " " + this['tour_guide_id'];
                var currentLocation = new google.maps.LatLng(laitude, longitude);
                createMarker(index, currentLocation, title);
            });
        },
        error: function (xhr) {
            alert('error');
        }
    });
}
$(document).ready(function () {
        
    $(function () {
        initialize();
        google.maps.event.addListener(map, 'click', function (event) {
            var duration = parseInt($('#durationOption').val());

            if (duration < 0) {
                duration = 1;
                $('#durationOption').val(duration);
            }
            marker.setDuration(duration);
            marker.setEasing($('#easingOption').val());
            marker.setPosition(event.latLng);
        });
           
    });
        
    $('#DemoAjaxClick').click(function () {
        setInterval(function () {
            $.ajax({
                url: "/Home/GetLocationTourGuide/20",
                type: "GET",
                dataType: 'json',
                contentType: 'application/json; charset=utf-8',
                async: true,
                processData: false,
                cache: false,
                success: function (result) {
                    var results = $.parseJSON(result);
                    $(results).each(function (index, value) {

                        var longitude = this['longitude'];
                        var laitude = this['latitude'];
                        var currentLocation = new google.maps.LatLng(laitude, longitude);
                        MoverMarker(currentLocation, index)
                    });
                },
                error: function (xhr) {
                    alert('error');
                }
            });
        }, 2000)
    });
    $("#Search").click(function () {
        var bla = $('#nametour').val();
        $.ajax({
            url: "/Home/SearchTourGuide/" + bla,
            type: "GET",
        })
        .done(function (partialViewResult) {
            $("#list-tour").html(partialViewResult);
        });
    });

});
function LoadMarker() {
    $.ajax({
        url: "/Home/CreateMarker/",
        type: "GET",
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        async: true,
        processData: false,
        cache: false,
        success: function (result) {
            var results = $.parseJSON(result);
            $(results).each(function (index, value) {
                var longitude = this['longitude'];
                var laitude = this['latitude'];
                var title = " " + this['tour_guide_id'];
                var currentLocation = new google.maps.LatLng(laitude, longitude);
                createMarker(index, currentLocation, title);
            });
        },
        error: function (xhr) {
            alert('error');
        }
    });
}
function MoverMarker(Latlng, index) {
    var duration = parseInt($('#durationOption').val());
    if (duration < 0) {
        duration = 1;
        $('#durationOption').val(duration);
    }
    listMarker[index].setDuration(duration);
    listMarker[index].setEasing($('#easingOption').val());
    listMarker[index].setPosition(Latlng);
}
function createMarker(index, latlng, title) {

    window.setTimeout(function () {
        listMarker[index] = new SlidingMarker({
            position: latlng,
            map: map,
            animation: google.maps.Animation.Gp,
            icon: pinImage,
            //shadow: pinShadow
        })
        listInforwindow[index] = new google.maps.InfoWindow({
            content: title
        });
        listInforwindow[index].open(map, listMarker[index]);
    }, 200);
}
function getMarkerSelected(id) {
    $.ajax({
        url: "/Home/GetLocationMarkerSelected/" + id,
        type: "GET",
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        async: true,
        processData: false,
        cache: false,
        success: function (result) {
            var results = $.parseJSON(result);
            $(results).each(function (index, value) {

                var longitude = this['longitude'];
                var laitude = this['latitude'];
                var location = new google.maps.LatLng(laitude, longitude);
                panTo(laitude, longitude);
                map.setZoom(15);
                for (i = 0 ; i < listMarker.length; i++) {

                    listMarker[i].setIcon(pinImage);

                }
                listMarker[id - 1].setIcon(pinImageSelect);

            });
        },
        error: function (xhr) {
            alert('error');
        }
    });
}
var panPath = [];
var panQueue = [];
var STEPS = 50;
function panTo(newLat, newLng) {
    if (panPath.length > 0) {
        panQueue.push([newLat, newLng]);
    } else {

        panPath.push("LAZY SYNCRONIZED LOCK");
        var curLat = map.getCenter().lat();
        var curLng = map.getCenter().lng();
        var dLat = (newLat - curLat) / STEPS;
        var dLng = (newLng - curLng) / STEPS;

        for (var i = 0; i < STEPS; i++) {
            panPath.push([curLat + dLat * i, curLng + dLng * i]);
        }
        panPath.push([newLat, newLng]);
        panPath.shift();
        setTimeout(doPan, 20);
    }
}

function doPan() {
    var next = panPath.shift();
    if (next != null) {
        map.panTo(new google.maps.LatLng(next[0], next[1]));
        setTimeout(doPan, 20);
    } else {

        var queued = panQueue.shift();
        if (queued != null) {
            panTo(queued[0], queued[1]);
        }
    }
}
function messageClick() {
    var bla = 2;
    $.ajax({
        url: "/Home/RenderHomeOption/" + bla,
        type: "GET",
    })
    .done(function (partialViewResult) {
        $("#primary-div").html(partialViewResult);
    });

}
function mapClick() {
    var bla = 1;
    $.ajax({
        url: "/Home/RenderHomeOption/" + bla,
        type: "GET",
    })
    .done(function (partialViewResult) {
        $("#primary-div").html(partialViewResult);
    });
}

